// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "RPG-card-generator",
    products: [
        .executable(name: "RPGCardGenerator", targets: ["RPG-card-generator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "2.2.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.4"),
    ],
    targets: [
        .target(name: "RPG-card-generator", dependencies: ["Files", "Rainbow"]),
    ]
)
