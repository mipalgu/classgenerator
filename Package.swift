// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "classgenerator",
    dependencies: [
        .package(url: "ssh://git.mipal.net/git/whiteboard_helpers.git", .branch("master"))
    ],
    targets: [
        .target(name: "classgenerator", dependencies: ["whiteboard_helpers"]),
        .testTarget(name: "classgeneratorTests", dependencies: [.target(name: "classgenerator")])
    ]
)
