// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "unity_levelplay_mediation",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(
            name: "unity-levelplay-mediation",
            targets: ["unity_levelplay_mediation"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/ironsource-mobile/LevelPlay-Swift-Package",
            exact: "9.6.1"
        ),
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "unity_levelplay_mediation",
            dependencies: [
                .product(name: "UnityMediationSDK", package: "LevelPlay-Swift-Package"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("LevelPlayNativeAdViewMedium.xib"),
                .process("LevelPlayNativeAdViewSmall.xib")
            ],
            cSettings: [
                .headerSearchPath("include/unity_levelplay_mediation")
            ]
        )
    ]
)
