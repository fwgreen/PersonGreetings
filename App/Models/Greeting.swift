import Vapor
import Fluent

final class Greeting : Model {

  var id: Node?
  var category: String
  var message: String
  var quantity: Int
  var price: Double

  var exists: Bool = false //for Fluent

  init(id: Node? = nil, category: String, message: String, quantity: Int, price: Double) {
    self.id = id
    self.category = category
    self.message = message
    self.quantity = quantity
    self.price = price
  }
}

extension Greeting {
  public convenience init(node: Node, in context: Context) throws {
    self.init(
      id: try node.extract("id"),
      category: try node.extract("category"),
      message: try node.extract("message"),
      quantity: try node.extract("quantity"),
      price: try node.extract("price")
    )
  }

  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id":id,
      "category": category,
      "message": message,
      "quantity": quantity,
      "price": price
    ])
  }
}

extension Greeting : Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(entity) { greeting in
      greeting.id()
      greeting.string("category")
      greeting.string("message")
      greeting.int("quantity")
      greeting.double("price")
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(entity)
  }
}
