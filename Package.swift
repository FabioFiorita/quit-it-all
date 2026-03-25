// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "QuitItAll",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "QuitItAll",
            path: "Sources/QuitItAll"
        )
    ]
)
