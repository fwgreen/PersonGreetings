import PackageDescription

let package = Package(
  name: "PersonalGreetings",
  dependencies: [
    .Package(url:"https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
    .Package(url:"https://github.com/vapor-community/postgresql-provider.git", majorVersion: 1, minor: 1)
  ],
  exclude: [
    "Config",
    "Resources"
  ]
)
