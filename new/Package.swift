// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "classgenerator",
    targets: [
        Target(name: "classgenerator", dependencies: [])
    ]
)

products.append(
    Product(
        name: "classgenerator",
        type: .Library(.Dynamic),
        modules: ["classgenerator"]
    )
)
