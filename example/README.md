# unity_levelplay_mediation_example

Demonstrates how to use the unity_levelplay_mediation plugin.

## Getting Started

This example demonstrates the `unity_levelplay_mediation` Flutter plugin.

Its iOS integration uses Swift Package Manager. Use Flutter 3.47.5+, Dart 3.13.4+, Xcode 26+, and an iOS 15+ app deployment target. The plugin and LevelPlay SDK support iOS 13+, while this example app targets iOS 15. Resolve the example dependencies and build with:

```sh
flutter config --enable-swift-package-manager
flutter pub get
flutter build ios --no-codesign
```

When building from source with Flutter 3.47.5, check out this repository into a directory named `unity_levelplay_mediation`. Flutter currently derives a local SPM package identity from the checkout path for this example's path dependency ([upstream issue](https://github.com/flutter/flutter/issues/186881)); the CI workflow uses that directory name.

The example links Unity Ads Adapter 5.11.0 with Swift Package Manager. Unity's LevelPlay SDK 9.6.1 is supplied by the Flutter plugin package.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
