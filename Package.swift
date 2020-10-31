// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "CallbagKit",
  products: [
    .library(name: "CallbagKit", targets: ["CallbagKit"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "CallbagKit", dependencies: []),
  ]
)