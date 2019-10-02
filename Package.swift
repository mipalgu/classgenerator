// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "classgenerator",
    products: [
        .executable(
            name: "classgenerator",
            targets: ["classgenerator_bin"]
        )
    ],
    dependencies: [
        .package(url: "ssh://git.mipal.net/git/swift_helpers.git", .branch("master")),
        .package(url: "ssh://git.mipal.net/git/whiteboard_helpers.git", .branch("master"))
    ],
    targets: [
        .target(name: "Data", dependencies: []),
        .target(name: "Containers", dependencies: []),
        .target(name: "Helpers", dependencies: ["whiteboard_helpers"]),
        .target(name: "Parsers", dependencies: [
            .target(name: "Data"),
            .target(name: "Containers"),
            .target(name: "Helpers"),
            "swift_helpers",
            "IO",
            "whiteboard_helpers"
        ]),
        .target(name: "Creators", dependencies: [
            .target(name: "Data"),
            .target(name: "Containers"),
            .target(name: "Helpers"),
            "swift_helpers",
            "IO",
            "whiteboard_helpers"
        ]),
        .target(name: "classgenerator", dependencies: [
            .target(name: "Data"),
            .target(name: "Containers"),
            .target(name: "Helpers"),
            .target(name: "Parsers"),
            .target(name: "Creators"),
            "swift_helpers",
            "IO",
            "whiteboard_helpers"
        ]),
        .target(name: "classgenerator_bin", dependencies: [.target(name: "classgenerator")]),
        .testTarget(
            name: "classgeneratorTests",
            dependencies: [.target(name: "classgenerator"), .target(name: "Helpers"), "swift_helpers"]
        )
    ]
)
