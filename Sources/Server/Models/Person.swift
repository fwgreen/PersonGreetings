import Vapor
import Fluent

final class Person : Model {

  var id: Node?
  var firstName: String
  var lastName: String
  var telephone: String
  var email: String

  var exists: Bool = false //for Fluent

  init(id: Node? = nil, firstName: String, lastName: String, telephone: String, email: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.telephone = telephone
    self.email = email
  }
}

extension Person {
  public convenience init(node: Node, in context: Context) throws {
    self.init(
      id: try node.extract("id"),
      firstName: try node.extract("firstname"),
      lastName: try node.extract("lastname"),
      telephone: try node.extract("telephone"),
      email: try node.extract("email")
    )
  }

  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id":id,
      "firstname": firstName,
      "lastname": lastName,
      "telephone": telephone,
      "email": email
    ])
  }
}

extension Person : Preparation {
  static func prepare(_ database: Database) throws {
    try database.create("persons") { user in
      user.id()
      user.string("firstname")
      user.string("lastname")
      user.string("telephone")
      user.string("email")
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete("persons")
  }
}
