// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "demo",
    products: [
        .library(name: "demo", targets: ["demo"])
    ],
    dependencies: [
        .package(url: "ssh://git.mipal.net/Users/Shared/git/swift_wb.git", .branch("master"))
    ],
    targets: [
        .target(name: "bridge", dependencies: []),
        .target(name: "demo", dependencies: [.target(name: "bridge"), "GUSimpleWhiteboard"]),
        .testTarget(
            name: "demoTests",
            dependencies: [
                .target(name: "bridge"),
                .target(name: "demo"),
                "GUSimpleWhiteboard"
            ]
        )
    ]
)
