import Vapor
import HTTP

final class PersonController {

  func detail(_ request: Request, user: Person) throws -> ResponseRepresentable {
    return try app.view.make("user/detail", [
      "title": "Test App",
      "heading": "User Detail",
      "user": user.makeNode()
    ])
  }

  func prepare(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("user/create", [
      "title": "Test App",
      "heading": "Create A User"
    ])
  }

  func create(_ request: Request) throws -> ResponseRepresentable {
    guard let first = request.data["first-name"]?.string,
          let last = request.data["last-name"]?.string,
          let phone = request.data["telephone"]?.string,
          let email = request.data["email"]?.string else {
      throw Abort.custom(status: .badRequest, message: "Incomplete Form")
    }
    var user = Person(firstName: first, lastName: last, telephone: phone, email: email)
    try user.save()
    return Response(redirect: "/user/all")
  }

  func edit(_ request: Request, user: Person) throws -> ResponseRepresentable {
    return try app.view.make("user/edit", [
      "title": "Test App",
      "heading": "Edit User",
      "user": user.makeNode()
    ])
  }

  func update(_ request: Request, updated: Person) throws -> ResponseRepresentable {
    var user = updated
    if let first = request.data["first-name"]?.string {
      user.firstName = first
    }
    if let last = request.data["last-name"]?.string {
      user.lastName = last
    }
    if let phone = request.data["telephone"]?.string {
      user.telephone = phone
    }
    if let email = request.data["email"]?.string {
      user.email = email
    }
    try user.save()
    return Response(redirect: "/user/all")
  }

  func all(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("user/table", [
      "title": "Test App",
      "heading": "All Users",
      "users": Person.all().makeNode()
    ])
  }

  func list(_ request: Request) throws -> ResponseRepresentable {
    let list = request.data["users"]?.array.flatMap { $0.map { Int($0.string ?? "") ?? 0 } } ?? []
    let users = try Person.query().filter("id", .in, list).all()
    return try app.view.make("user/table", [
      "title": "Test App",
      "heading": "Some Users",
      "users": users.makeNode()
    ])
  }

  func delete(_ request: Request, user: Person) throws -> ResponseRepresentable {
    try user.delete()
    return Response(redirect: "/user/all")
  }
}
