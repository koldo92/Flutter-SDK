## Unreleased

- Upgraded the Android and iOS LevelPlay SDKs to 9.8.0.
- Incorporated the upstream iOS multiple-engine registration and plugin framework version fixes.
- Updated the minimum requirements to Flutter 3.50 and Dart 3.14, and aligned Android builds with AGP 9.3.1 and Gradle 9.5.0.

## 10.0.0

### Breaking Changes
- Migrated the plugin to Flutter's Built-in Kotlin support. Removed the explicit Kotlin Gradle Plugin (`org.jetbrains.kotlin.android`) and KGP buildscript classpath from `android/build.gradle`, replacing `kotlinOptions` with `kotlin.compilerOptions` (`jvmTarget = JVM_17`).
- Removed obsolete Kotlin plugin declarations from `android/settings.gradle`.
- Updated minimum supported SDK requirements to Flutter >= 3.44.0 and Dart >= 3.12.0 for built-in Kotlin support.
- Migrated the example app to built-in Kotlin (`android.builtInKotlin=true`), AGP 9.0.1, and Gradle 9.1.0.
- iOS now uses **Swift Package Manager only**; CocoaPods integration has been removed, including from the example app.
- iOS apps must be built with Xcode 26 or later, as required by native SDK 9.7.0.

### SDK Updates
- Upgraded iOS native SDK to **9.7.0** via official `LevelPlay-Swift-Package`.
- Upgraded Android native SDK to **9.7.0** via `com.unity3d.ads-mediation:mediation-sdk:9.7.0`.

### New Features & Enhancements
- Integrated upstream Flutter SDK 9.3.0 (`0bc534bd11fb2b348c8dc6f66022f4ff2a8df3da`).
- Added per-instance impression data listeners for Interstitial, Rewarded, and Banner ads.
- Added `LevelPlayAdSize.LEADERBOARD` (728x90) banner size.
- Added `LevelPlayPrivacySettings.setGDPRConsent(bool)` API; deprecated `setGDPRConsents` in favor of it.
- Global impression data listeners are deprecated by the native SDKs; use per-instance listeners.
- Replaced deprecated `Color.value` with `Color.toARGB32()`.
- Upgraded dev linter to `flutter_lints: ^6.0.0`.
- Added Android example build CI and static analysis to the existing iOS SPM workflow.

### Bug Fixes
- Fixed Android activity reattachment after configuration changes so interstitial and rewarded ads can still be shown.
- Added null-safety protections for `errorMessage`, `placementName`, and `creativeId` in Dart and native iOS serialization.
- Preserved SPM native ad resource bundle loading.

## 9.2.0

### Features
- Add LevelPlayPrivacySettings API with support for GDPR, CCPA, and COPPA compliance

## 9.1.0

### SDK Updates
- Wraps Android SDK 9.4.0 API
- Wraps iOS SDK 9.4.0 API


## 9.0.1

### Bug Fixes
- Fixed Android dependency configuration to resolve compile-time class resolution issues

## 9.0.0

### Breaking Changes
- **Package renamed** from `ironsource_mediation` to `unity_levelplay_mediation`
- The old plugin `ironsource_mediation` is now **deprecated**
- Removal of old deprecated IronSource classes and methods

### SDK Updates
- Wraps Android SDK 9.2.0 API
- Wraps iOS SDK 9.2.0 API

### Bug Fixes
Fixed iOS test suite launch
Fixed NullPointerException crash in Android when banner/native ad callbacks fire after view disposal

## 3.2.0 , 2025

> **DEPRECATION NOTICE**: This is the last version published under the package name `ironsource_mediation`. The package has been renamed to `unity_levelplay_mediation` starting from version 9.0.0. Please migrate to the new package.

- Android SDK: 8.10.0
- iOS SDK: 8.10.0

## 3.1.2 , 2025

- Android SDK: 8.9.1
- iOS SDK: 8.9.1

## 3.1.1 , 2025

- Android SDK: 8.9.0
- iOS SDK: 8.9.0

## 3.1.0 , 2025

- Android SDK: 8.6.1
- iOS SDK: 8.6.0

## 3.0.1 , 2024

- Android SDK: 8.4.0
- iOS SDK: 8.4.0

## 3.0.0 , 2024

- Android SDK: 8.4.0
- iOS SDK: 8.4.0

## 2.0.0 , 2024

- Android SDK: 8.1.0
- iOS SDK: 8.1.0

## 1.2.1 , 2024

- Android SDK: 7.9.0
- iOS SDK: 7.9.0

## 1.2.0 , 2023

- Android SDK: 7.3.0.1
- iOS SDK: 7.3.0

## 1.1.0 , 2022

- Android SDK: 7.2.1.1
- iOS SDK: 7.2.1.2

## 1.0.0 , 2022

- Android SDK: 7.2.1.1
- iOS SDK: 7.2.1.2
