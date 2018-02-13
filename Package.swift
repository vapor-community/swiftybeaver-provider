// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftyBeaverProvider",
    products: [
        .library(name: "SwiftyBeaverProvider", targets: ["SwiftyBeaverProvider"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .exact("3.0.0-beta.3")),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "1.5.0"))
    ],
    targets: [
        .target(name: "SwiftyBeaverProvider", dependencies: ["SwiftyBeaver", "Vapor"]),
        .testTarget(name: "SwiftyBeaverProviderTests", dependencies: ["SwiftyBeaverProvider"])
    ]
)
