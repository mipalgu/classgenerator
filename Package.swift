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
        .package(url: "ssh://git.mipal.net/Users/Shared/git/swift_helpers.git", .branch("master")),
        .package(url: "ssh://git.mipal.net/Users/Shared/git/whiteboard_helpers.git", .branch("master"))
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
        .target(name: "Main", dependencies: [
            .target(name: "Data"),
            .target(name: "Containers"),
            .target(name: "Helpers"),
            .target(name: "Parsers"),
            .target(name: "Creators"),
            "swift_helpers",
            "IO",
            "whiteboard_helpers"
        ]),
        .target(name: "classgenerator_bin", dependencies: [.target(name: "Main")]),
        .testTarget(
            name: "classgeneratorTests",
            dependencies: [.target(name: "Main"), .target(name: "Helpers"), "swift_helpers"]
        )
    ]
)
