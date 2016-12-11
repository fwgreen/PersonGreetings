import Vapor
import HTTP

final class PersonController {

  let directives = Node(["home": "/person", "create": "/person/new", "list": "/person/all", "help": "/person/help"])

  func index(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("person/index", [
      "title": "Test App",
      "heading": "Persons",
      "directives": directives
    ])
  }

  func help(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("person/help", [
      "title": "Test App",
      "heading": "Persons",
      "directives": directives
    ])
  }

  func detail(_ request: Request, person: Person) throws -> ResponseRepresentable {
    return try app.view.make("person/detail", [
      "title": "Test App",
      "heading": "Person Detail",
      "person": person.makeNode(),
      "directives": directives
    ])
  }

  func prepare(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("person/create", [
      "title": "Test App",
      "heading": "Create A Person",
      "directives": directives
    ])
  }

  func create(_ request: Request) throws -> ResponseRepresentable {
    guard let first = request.data["first-name"]?.string,
          let last = request.data["last-name"]?.string,
          let phone = request.data["telephone"]?.string,
          let email = request.data["email"]?.string else {
      throw Abort.custom(status: .badRequest, message: "Incomplete Form")
    }
    var person = Person(firstName: first, lastName: last, telephone: phone, email: email)
    try person.save()
    return Response(redirect: "/person/all")
  }

  func edit(_ request: Request, person: Person) throws -> ResponseRepresentable {
    return try app.view.make("person/edit", [
      "title": "Test App",
      "heading": "Edit Person",
      "person": person.makeNode(),
      "directives": directives
    ])
  }

  func update(_ request: Request, updated: Person) throws -> ResponseRepresentable {
    var person = updated
    if let first = request.data["first-name"]?.string {
      person.firstName = first
    }
    if let last = request.data["last-name"]?.string {
      person.lastName = last
    }
    if let phone = request.data["telephone"]?.string {
      person.telephone = phone
    }
    if let email = request.data["email"]?.string {
      person.email = email
    }
    try person.save()
    return Response(redirect: "/person/all")
  }

  func all(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("person/table", [
      "title": "Test App",
      "heading": "All Persons",
      "persons": Person.all().makeNode(),
      "directives": directives
    ])
  }

  func list(_ request: Request) throws -> ResponseRepresentable {
    var persons: [Person] = []
    let list = request.data["persons"]?.array.flatMap { $0.map { Int($0.string ?? "") ?? 0 } } ?? []
    if !list.isEmpty {
      persons = try Person.query().filter("id", .in, list).all()
    }
    return try app.view.make("person/table", [
      "title": "Test App",
      "heading": "Some Users",
      "persons": persons.makeNode(),
      "directives": directives
    ])
  }

  func delete(_ request: Request, person: Person) throws -> ResponseRepresentable {
    try person.delete()
    return Response(redirect: "/person/all")
  }
}
