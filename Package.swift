// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftyBeaverProvider",
    products: [
        .library(name: "SwiftyBeaverProvider", targets: ["SwiftyBeaverProvider"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "2.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "1.4.0"))
    ],
    targets: [
        .target(name: "SwiftyBeaverProvider", dependencies: ["SwiftyBeaver", "Vapor"]),
        .testTarget(name: "SwiftyBeaverProviderTests", dependencies: ["SwiftyBeaverProvider"])
    ]
)
