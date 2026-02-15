// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "swift-vision-ui",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "VisionUI", targets: ["VisionUI"]),
    ],
    dependencies: [
        .package(path: "../OpenFoundationModels"),
        .package(path: "../SwiftAgent"),
    ],
    targets: [
        .target(
            name: "VisionUI",
            dependencies: [
                .product(name: "OpenFoundationModels", package: "OpenFoundationModels"),
                .product(name: "SwiftAgent", package: "SwiftAgent"),
            ]
        ),
        .testTarget(
            name: "VisionUITests",
            dependencies: [
                "VisionUI",
                .product(name: "OpenFoundationModels", package: "OpenFoundationModels"),
            ]
        ),
    ]
)
