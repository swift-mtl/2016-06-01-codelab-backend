import KituraSys
import KituraNet
import Kitura

public let config = Configuration()

let router = Router()

/// Setup database
let todos: TodoDAOProtocol = TodoCollection()
todos.addTest(name: "Beer", detail: "Heineken", completed: false)

todos.addTest(name: "Cheese", detail: "Brie", completed: false)

todos.addTest(name: "Bread", detail: "Naan", completed: false)

/// Call a helper function to create routes in App.swift
/// Set up middleware to parse incoming JSON in the body of client requests
setupRoutes(router: router, todos: todos)

///
/// Start the server
///
guard let port = config.port else {
    "Could not initialize environment. Exiting..."
    fatalError()
}

let server = HTTPServer.listen(port: port, delegate: router)
Server.run()