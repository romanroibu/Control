// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Control",
    products: [
        .library(
            name: "Control",
            targets: ["Control"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Control",
            dependencies: []),
        .testTarget(
            name: "ControlTests",
            dependencies: ["Control"]),
    ]
)
