import PackageDescription

let package = Package(
  name: "PersonalGreetings",
  dependencies: [
    .Package(url:"https://github.com/vapor/vapor.git", majorVersion: 1),
    .Package(url:"https://github.com/vapor/sqlite-provider.git", majorVersion: 1)
  ],
  exclude: [
    "Resources"
  ]
)
