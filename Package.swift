// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "StacksReader",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "StacksReader",
            targets: ["StacksReader"]
        ),
    ],
    targets: [
        .target(
            name: "CppEngine",
            path: "Sources/CppEngine",
            publicHeadersPath: "include",
            cxxSettings: [
                .unsafeFlags(["-O3", "-std=c++20"])
            ]
        ),
        .target(
            name: "StacksReader",
            dependencies: ["CppEngine"],
            path: "Sources/StacksReader",
            resources: [
                .copy("../../Resources") 
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        )
    ]
)
