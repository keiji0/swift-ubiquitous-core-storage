// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UbiquitousCoreStorage",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UbiquitousCoreStorage",
            targets: ["UbiquitousCoreStorage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/keiji0/swift-app-tools",
            branch: "main"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UbiquitousCoreStorage",
            dependencies: [
                .product(name: "AppTools", package: "swift-app-tools"),
            ]),
        .testTarget(
            name: "UbiquitousCoreStorageTests",
            dependencies: [
                "UbiquitousCoreStorage",
                .product(name: "AppTools", package: "swift-app-tools"),
            ]),
    ]
)
