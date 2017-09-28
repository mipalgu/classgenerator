// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "classgenerator",
    targets: [
        .target(name: "classgenerator", dependencies: []),
        .testTarget(name: "classgeneratorTests", dependencies: [.target(name: "classgenerator")])
    ]
)
