import 'package:flutter_test/flutter_test.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

void main() {
  test('standard banner size remains compatible', () {
    expect(LevelPlayAdSize.BANNER.width, 320);
    expect(LevelPlayAdSize.BANNER.height, 50);
    expect(LevelPlayAdSize.BANNER.adLabel, 'BANNER');
  });
}
