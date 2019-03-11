// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "demo",
    products: [
        .library(name: "demo", targets: ["bridge"])
    ],
    dependencies: [
        .package(url: "ssh://git.mipal.net/git/CGUSimpleWhiteboard.git", .branch("master")),
        .package(url: "ssh://git.mipal.net/git/swift_wb.git", .branch("master"))
    ],
    targets: [
        .target(name: "bridge", dependencies: []),
        .testTarget(
            name: "demoTests",
            dependencies: [
                .target(name: "bridge"),
                "GUSimpleWhiteboard"
            ]
        )
    ]
)
