# Unity LevelPlay Flutter Plugin

A bridge plugin for LevelPlay SDKs.

- [LevelPlay Knowledge Center](https://developers.is.com/)
- [Android SDK](https://developers.ironsrc.com/ironsource-mobile/android/android-sdk/)
- [iOS SDK](https://developers.ironsrc.com/ironsource-mobile/ios/ios-sdk/)
- [Flutter Plugin](https://developers.is.com/ironsource-mobile/flutter/flutter-plugin/)

# Getting Started

## Installation

```
flutter pub get unity_levelplay_mediation
```

## Android Configuration

- The LevelPlay SDK dependency is included in the plugin, so you do not have to add manually to your build.gradle.

### Gradle Dependencies Required

- Play Services dependencies must be added to PROJECT_ROOT/android/app/build.gradle.

```groovy
// PROJECT_ROOT/android/app/build.gradle
dependencies {
  ...
    implementation 'com.google.android.gms:play-services-appset:16.0.2'
    implementation 'com.google.android.gms:play-services-ads-identifier:18.0.1'
    implementation 'com.google.android.gms:play-services-basement:18.3.0'
}
```

## iOS Configuration

- The plugin integrates Unity's official [LevelPlay Swift package](https://github.com/ironsource-mobile/LevelPlay-Swift-Package) and resolves native iOS SDK **9.6.1**. Flutter's Swift Package Manager integration is required; CocoaPods is not supported for this plugin.
- Requires Flutter 3.47.5 or later, Dart 3.13.4 or later, Xcode 26 or later, and an iOS 15 or later app deployment target. The plugin's SPM target and LevelPlay SDK support iOS 13; Flutter 3.47.5 enables SPM by default and requires iOS 15 for this example app. See [Flutter's plugin author guide](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-plugin-authors).
- Unity's SPM package supplies the `UnityMediationSDK` product, its Ad Quality dependency, and its required system frameworks and libraries. Do not add a second LevelPlay SDK dependency.
- Add `-ObjC` to the iOS app target's **Other Linker Flags**, as required by Unity's SPM integration instructions. The example app already sets this flag.

Enable Flutter's Swift Package Manager integration, then resolve packages and build the iOS app:

```sh
flutter config --enable-swift-package-manager
flutter pub get
cd example
flutter build ios --no-codesign
```

Applications may continue using CocoaPods for other plugins that have not migrated, but this plugin and LevelPlay SDK must be integrated through Swift Package Manager only. If you use a LevelPlay mediation adapter, add its official Swift package and select a version compatible with LevelPlay 9.6.1. The example uses Unity Ads Adapter 5.11.0 through its [official Swift package](https://github.com/ironsource-mobile/LevelPlay-UnityAds-Adapter-Swift-Package).

### <ins>SKAdNetwork Support</ins>

Add the SKAN ID of IronSource Network on info.plist

```xml
<key>SKAdNetworkItems</key>
<array>
   <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>su67r6k2v3.skadnetwork</string>
   </dict>
</array>
```

### <ins>App Transport Security Settings</ins>

Set [NSAllowsArbitraryLoads](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsallowsarbitraryloads): `true` on info.plist to allow http as some mediated networks require http calls. (Note: LevelPlay Network calls are all encrypted.)

Note:

- Make sure that your info.plist does not contain other ATS exceptions such as [NSAllowsArbitraryLoadsInWebContent](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsallowsarbitraryloadsinwebcontent).

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

### <ins>App Tracking Transparency (ATT) Prompt</ins>

<b>TODO: Remove or keep this?</b>

Implement the ATT prompt to request user authorization for app-related data.

- Note: This is not part of LevelPlay SDK but a bridge for `AppTrackingTransparency ATTrackingManager`.
- You have to add `NSUserTrackingUsageDescription` to your info.plist if you intend to call this API.

```dart
Future<void> checkATT() async {
  final currentStatus = await ATTrackingManager.getTrackingAuthorizationStatus();
  if (currentStatus == ATTStatus.NotDetermined) {
    final returnedStatus = await ATTrackingManager.requestTrackingAuthorization();
    print('ATTStatus returned: $returnedStatus');
  }
  return;
}
```

Read more about Apple's ATT and user privacy guideline [here](https://developer.apple.com/app-store/user-privacy-and-data-use/).

## General Usage

### Implement Listeners

#### LevelPlayRewardedAdListener
```dart
class LevelPlayRewardedAdListenerClass with LevelPlayRewardedAdListener {
  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    // Provided when the ad is successfully loaded
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    // Provided when the ad fails to load. Ad Unit information is included
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    // Provided when the ad is displayed. This is equivalent to an impression
  }

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    // Provided when the ad fails to be displayed
  }

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    // Provided when the user clicks on the ad
  }

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    // Provided when the ad is closed
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {
    // Provided when the ad info is updated. Available when another ad has loaded, and includes a higher CPM/Rate
  }

  @override
  void onAdRewarded(LevelPlayReward reward, LevelPlayAdInfo adInfo) {
    // The user completed to watch the video, and should be rewarded. 
    // The reward parameter will include the reward data.
  }
}
```

#### LevelPlayInterstitialAdListener
```dart
class LevelPlayInterstitialAdListenerClass with LevelPlayInterstitialAdListener {
  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    // Provided when the ad is successfully loaded
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    // Provided when the ad fails to load. Ad Unit information is included
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    // Provided when the ad is displayed. This is equivalent to an impression
  }

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    // Provided when the ad fails to be displayed
  }
  
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    // Provided when the user clicks on the ad
  }

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    // Provided when the ad is closed
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {
    // Provided when the ad info is updated. Available when another ad has loaded, and includes a higher CPM/Rate
  }
}
```

#### LevelPlayBannerAdViewListener
```dart
class LevelPlayBannerAdViewListenerClass with LevelPlayBannerAdViewListener {
  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    // Ad was loaded successfully 
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    // Ad load failed
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    // Ad was displayed and visible on screen
  }

  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {
    // Ad failed to be displayed on screen
  }
  
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    // Ad was clicked
  }

  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {
    // Ad is opened on full screen
  }

  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {
    // Ad is restored to its original size
  }

  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {
    // User pressed on the ad and was navigated out of the app 
  }
}
```

#### LevelPlayNativeAdListener
```dart
class LevelPlayNativeAdListenerClass with LevelPlayNativeAdListener {
  @override
  void onAdLoaded(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    // Invoked each time a native ad was loaded.
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd nativeAd, IronSourceError error) {
    // Invoked when the native ad loading process has failed.
  }

  @override
  void onAdImpression(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    // Invoked each time the first pixel is visible on the screen
  }
  
  @override
  void onAdClicked(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    // Invoked when end user clicked on the native ad
  }
}
```

### Initialize the plugin 

```dart
Future<void> init() async {
  final appKey = '[YOUR_APP_KEY]';
  final userId = '[YOUR_USER_ID]';
  try {
    final initRequest = LevelPlayInitRequest.builder(configState.appKey)
        .withUserId(userId)
        .build();
    await LevelPlay.init(initRequest: initRequest, initListener: this);
  } on PlatformException catch (e) {
    print(e);
  }
}
```

### Show Ads Example

#### LevelPlayRewardedVideo
```dart
final LevelPlayRewardedAd _rewardedAd = LevelPlayRewardedAd(adUnitId: [YOUR_AD_UNIT]);

@override
void initState() {
  super.initState();
  _rewardedAd.setListener([YOUR_LISTENER]);
}

void _loadRewarded() {
  _rewardedAd.loadAd();
}

Future<void> _showRewarded() async {
  if (await _rewardedAd.isAdReady()) {
    _rewardedAd.showAd(placement: [YOUR_PLACEMENT]);
  }
}

// Rest of the class
```

#### LevelPlayInterstitial

```dart
final LevelPlayInterstitialAd _interstitialAd = LevelPlayInterstitialAd(adUnitId: [YOUR_AD_UNIT]);

@override
void initState() {
  super.initState();
  _interstitialAd.setListener([YOUR_LISTENER]);
}

void _loadInterstitial() {
  _interstitialAd.loadAd();
}

Future<void> _showInterstitial() async {
  if (await _interstitialAd.isAdReady()) {
    _interstitialAd.showAd(placement: [YOUR_PLACEMENT]);
  }
}

// Rest of the class
```

#### LevelPlayBanner

```dart
final _bannerKey = GlobalKey<LevelPlayBannerAdViewState>();
final _adSize = LevelPlayAdSize.BANNER;
final _adUnitId = 'YOUR_AD_UNIT_ID';
final _placementName = 'YOUR_PLACEMENT';

void _loadAd() {
  _bannerKey.currentState?.loadAd();
  // or store LevelPlayBannerAdView in variable and call '_bannerAdView.loadAd();'
}

@override
Widget build(BuildContext context) {
  return
    LevelPlayBannerAdView(
      key: _bannerKey,
      adUnitId: _adUnitId,
      adSize: _adSize,
      listener: this,
      placementName: _placementName,
      onPlatformViewCreated: () {
        _loadAd();
      },
    );
}
```

#### LevelPlayNativeAd
```dart
LevelPlayNativeAd? _nativeAd;

@override
void initState() {
  super.initState();
  _nativeAd = LevelPlayNativeAd.builder()
      .withPlacementName(_placementName)
      .withListener(this)
      .build();
}

@override
Widget build(BuildContext context) {
  return
    LevelPlayNativeAdView(
      height: _height,
      width: _width,
      nativeAd: _nativeAd,
      templateType: _templateType,
    );
}
```

Refer to the [example app](./example) for the more detailed implementation sample.

Note:

- Make sure to read the official documents at [LevelPlay Knowledge Center](TODO: replace with the real KC link) for proper usage.
- Some configurations must be done before initialization.
- LevelPlayBannerListener is deprecated - Please use LevelPlayBannerAdViewListener with LevelPlayBannerAdView instead.
- LevelPlayInterstitialListener is deprecated - Please use LevelPlayInterstitialAdListener with LevelPlayInterstitialAd instead.
- 
# Mediation

- You can use the LevelPlay's mediation feature by adding adapters/SDKs to your project.
- Some networks require additional configurations.
- Make sure to use the compatible adapter versions.

## Android

Make sure to follow [LevelPlay Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/android/mediation-networks-android/) document for additional setup.

- Add dependencies to `YOUR_PROJECT/android/app/build.gradle`
- Add required settings to `YOUR_PROJECT/android/app/src/main/AndroidManifest.xml`

## iOS

Make sure to follow [LevelPlay Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/ios/mediation-networks-ios/) document for additional setup.

- Add each desired network adapter using its official Swift package, at a version compatible with LevelPlay 9.6.1. Do not add a LevelPlay SDK pod or CocoaPod adapter alongside the SPM SDK.
- Add required settings to `YOUR_PROJECT/ios/Runner/info.plist`
