// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftyBeaverProvider",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "SwiftyBeaverProvider", targets: ["SwiftyBeaverProvider"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.6.0")
    ],
    targets: [
        .target(name: "SwiftyBeaverProvider", dependencies: ["SwiftyBeaver", "Vapor"]),
        .testTarget(name: "SwiftyBeaverProviderTests", dependencies: ["SwiftyBeaverProvider"])
    ]
)
