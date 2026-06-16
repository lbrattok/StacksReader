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
            targets: ["UI"]
        ),
    ],
    targets: [
        .target(
            name: "CppBack",
            path: "Sources/CppBack",
            publicHeadersPath: "include",
            cxxSettings: [
                .unsafeFlags(["-O3", "-std=c++20"])
            ]
        ),

        .target(
            name: "Core",
            dependencies: ["CppBack"],
            path: "Sources/Core",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),

        .target(
            name: "UI",
            dependencies: ["Core", "CppBack"],
            path: "Sources/UI",
            resources: [
                .copy("../../Resources") // Копируем MathJax и HTML в итоговый бандл
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        )
    ]
)
