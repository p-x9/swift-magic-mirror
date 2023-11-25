// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MagicMirror",
    products: [
        .library(
            name: "MagicMirror",
            targets: ["MagicMirror"]
        ),
    ],
    targets: [
        .target(
            name: "MagicMirror"
        ),
        .testTarget(
            name: "MagicMirrorTests",
            dependencies: ["MagicMirror"]
        ),
    ]
)
