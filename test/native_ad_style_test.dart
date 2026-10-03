import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

void main() {
  test('native ad element colors serialize as ARGB32', () {
    final style = LevelPlayNativeAdElementStyle(
      backgroundColor: const Color(0xFF123456),
      textColor: const Color(0x80112233),
    );

    expect(style.toMap(), <String, dynamic>{
      'backgroundColor': 0xFF123456,
      'textSize': null,
      'textColor': 0x80112233,
      'fontStyle': null,
      'cornerRadius': null,
    });
  });

  test('native ad template background color serializes as ARGB32', () {
    final style = LevelPlayNativeAdTemplateStyle(
      mainBackgroundColor: const Color(0xFFABCDEF),
    );

    expect(style.toMap()['mainBackgroundColor'], 0xFFABCDEF);
  });
}
