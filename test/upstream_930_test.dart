import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

class _ImpressionListener implements LevelPlayImpressionDataListener {
  final impressions = <LevelPlayImpressionData>[];

  @override
  void onImpressionSuccess(LevelPlayImpressionData impressionData) {
    impressions.add(impressionData);
  }
}

Map<String, dynamic> _adInfo() => {
  'adId': 'ad',
  'adUnitId': 'unit',
  'adUnitName': 'Test unit',
  'adFormat': 'INTERSTITIAL',
  'placementName': null,
  'auctionId': 'auction',
  'country': 'ES',
  'ab': '',
  'segmentName': '',
  'adNetwork': 'network',
  'instanceName': 'instance',
  'instanceId': 'instance-id',
  'revenue': 0.01,
  'precision': 'BID',
  'encryptedCPM': '',
  'creativeId': null,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('unity_levelplay_mediation');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('missing and null native strings use empty fallbacks', () {
    for (final omit in [false, true]) {
      final info = _adInfo();
      final error = <String, dynamic>{'errorCode': 100, 'errorMessage': null};
      if (omit) {
        info.remove('placementName');
        info.remove('creativeId');
        error.remove('errorMessage');
      }
      final parsedInfo = LevelPlayAdInfo.fromMap(info);
      expect(parsedInfo.placementName, isEmpty);
      expect(parsedInfo.creativeId, isEmpty);
      expect(parsedInfo.revenue, 0.01);
      final parsedError = LevelPlayAdError.fromMap(error);
      expect(parsedError.errorMessage, isEmpty);
      expect(parsedError.errorCode, 100);
    }
  });

  test('non-null native strings are preserved', () {
    final info = _adInfo()
      ..['placementName'] = 'Default'
      ..['creativeId'] = 'creative';
    final parsed = LevelPlayAdInfo.fromMap(info);
    expect(parsed.placementName, 'Default');
    expect(parsed.creativeId, 'creative');
    expect(
      LevelPlayAdError.fromMap({
        'errorCode': 100,
        'errorMessage': 'Load failed',
      }).errorMessage,
      'Load failed',
    );
  });

  test(
    'leaderboard round-trips while medium rectangle keeps its native label',
    () {
      final size = LevelPlayAdSize.createAdSize(adSize: 'LEADERBOARD');
      expect(size.width, 728);
      expect(size.height, 90);
      expect(
        LevelPlayAdSize.fromMap(size.toMap()),
        LevelPlayAdSize.LEADERBOARD,
      );
      expect(
        LevelPlayAdSize.MEDIUM_RECTANGLE.toMap()['adLabel'],
        'MEDIUM_RECTANGLE',
      );
    },
  );

  test(
    'GDPR consent forwards both values through the native channel',
    () async {
      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return null;
      });
      await LevelPlayPrivacySettings.setGDPRConsent(true);
      await LevelPlayPrivacySettings.setGDPRConsent(false);
      expect(calls.map((call) => call.method), [
        'setGDPRConsent',
        'setGDPRConsent',
      ]);
      expect(calls.map((call) => call.arguments), [
        {'consent': true},
        {'consent': false},
      ]);
    },
  );

  test('impressions route by ad ID and stop after disposal', () async {
    var nextId = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'createInterstitialAd' ||
          call.method == 'createRewardedAd') {
        return 'ad-${nextId++}';
      }
      return null;
    });
    final first = LevelPlayInterstitialAd(adUnitId: 'interstitial');
    final second = LevelPlayInterstitialAd(adUnitId: 'interstitial');
    final rewarded = LevelPlayRewardedAd(adUnitId: 'rewarded');
    final firstListener = _ImpressionListener();
    final secondListener = _ImpressionListener();
    final rewardedListener = _ImpressionListener();
    first.setImpressionDataListener(firstListener);
    second.setImpressionDataListener(secondListener);
    rewarded.setImpressionDataListener(rewardedListener);

    try {
      await first.loadAd();
      await second.loadAd();
      await rewarded.loadAd();
      final payload = {'auctionId': 'auction', 'revenue': 0.02};
      Future<void> emit(String method, String adId) async {
        await LevelPlay.handleMethodCall(
          MethodCall(method, {'adId': adId, 'impressionData': payload}),
        );
      }

      await emit('onInterstitialAdImpressionSuccess', second.adId);
      expect(firstListener.impressions, isEmpty);
      expect(secondListener.impressions.single.revenue, 0.02);
      expect(rewardedListener.impressions, isEmpty);

      await emit('onRewardedAdImpressionSuccess', rewarded.adId);
      expect(rewardedListener.impressions.single.auctionId, 'auction');

      // Ads without an impression listener must still accept native callbacks.
      final withoutListener = LevelPlayRewardedAd(adUnitId: 'rewarded');
      try {
        await withoutListener.loadAd();
        await emit('onRewardedAdImpressionSuccess', withoutListener.adId);
      } finally {
        await withoutListener.dispose();
      }

      await second.dispose();
      await emit('onInterstitialAdImpressionSuccess', second.adId);
      expect(secondListener.impressions, hasLength(1));
    } finally {
      await first.dispose();
      await second.dispose();
      await rewarded.dispose();
    }
  });
}
