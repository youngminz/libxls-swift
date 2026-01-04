// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "libxls-swift",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "LibXLS",
            targets: ["LibXLS"]
        )
    ],
    targets: [
        .target(
            name: "Clibxls",
            path: "Sources/Clibxls"
        ),
        .target(
            name: "LibXLS",
            dependencies: ["Clibxls"],
            path: "Sources/LibXLS"
        ),
        .testTarget(
            name: "LibXLSTests",
            dependencies: ["LibXLS"],
            path: "Tests/LibXLSTests"
        )
    ]
)
