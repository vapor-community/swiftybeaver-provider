// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftyBeaverProvider",
    products: [
        .library(name: "SwiftyBeaverProvider", targets: ["SwiftyBeaverProvider"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.5.2")
    ],
    targets: [
        .target(name: "SwiftyBeaverProvider", dependencies: ["SwiftyBeaver", "Vapor"]),
        .testTarget(name: "SwiftyBeaverProviderTests", dependencies: ["SwiftyBeaverProvider"])
    ]
)
