import KituraSys
import KituraNet
import Kitura

public let config = Configuration()

let router = Router()

/// Setup database
let todos: TodoDAOProtocol = TodoCollection()

todos.add(name: "Beer", description: "Heineken", completed: false) { todo in
    // on complete
}

todos.add(name: "Cheese", description: "Brie", completed: false) { todo in
    // on complete
}

todos.add(name: "Bread", description: "Naan", completed: false) { todo in
    // on complete
}

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