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
        .package(url: "https://github.com/mipalgu/swift_helpers.git", .branch("main")),
        .package(url: "https://github.com/mipalgu/whiteboard_helpers.git", .branch("main"))
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
