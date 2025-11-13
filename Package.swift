// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "MyTool",
    dependencies: [
        .package(url: "https://github.com/jamesrochabrun/SwiftAnthropic.git", from: "2.1.9"),
    ],
    targets: [
        .executableTarget(
            name: "AIManager",
            dependencies: ["SwiftAnthropic"]
        )
    ]
)