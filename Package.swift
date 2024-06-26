// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocialAuthentication",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SocialAuthentication",
            targets: ["SocialAuthentication"]),
    ],
    dependencies: [
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", .upToNextMinor(from: "16.3.1")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", .upToNextMinor(from: "7.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SocialAuthentication",
            dependencies: [
                .product(name: "FacebookLogin", package: "facebook-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ],
            exclude: ["../../Example"],
            resources: [.copy("../../Sources/Resources/PrivacyManifest/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SocialAuthenticationTests",
            dependencies: ["SocialAuthentication"]),
    ]
)
