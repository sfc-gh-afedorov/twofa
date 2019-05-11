// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let platformTarget: Target

#if os(macOS)
platformTarget = .target(
    name: "TwoFaMac",
    dependencies: ["TwoFaCore", "KeychainAccess"])
#elseif os(Linux)
platformTarget = .target(
    name: "TwoFaLinux",
    dependencies: ["TwoFaCore"])
#endif

var package = Package(
    name: "TwoFa",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander", from: "0.8.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/norio-nomura/Base32", from: "0.5.4"),
        .package(url: "https://github.com/kirsis/OneTimePassword", .branch("swiftpmtest")),
    ],
    targets: [
        
        // Executable
        .target(
            name: "TwoFa",
            dependencies: ["TwoFaCore", Target.Dependency(stringLiteral: platformTarget.name)]),
        .testTarget(
            name: "TwoFaTests",
            dependencies: ["TwoFa"]),
        
        // Domain logic
        .target(
            name: "TwoFaCore",
            dependencies: ["Base32", "Commander", "Rainbow", "OneTimePassword"]),
        .testTarget(
            name: "TwoFaCoreTests",
            dependencies: ["TwoFaCore"]),
        
        // Platform-specific
        platformTarget,
        .testTarget(
            name: "\(platformTarget.name)Tests",
            dependencies: [Target.Dependency(stringLiteral: platformTarget.name)])
    ]
)
#if os(OSX)
        package.dependencies.append(.package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "3.0.0"))
#endif
