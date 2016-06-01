import Kitura
import KituraNet

import SwiftyJSON
import LoggerAPI

/**
 Custom middleware that allows Cross Origin HTTP requests
 This will allow wwww.todobackend.com to communicate with your server
 */
class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        
        response.headers["Access-Control-Allow-Origin"] = "*"
        
        next()
    }
}


func setupRoutes(router: Router, todos: TodoDAOProtocol) {
    
    router.all("/*", middleware: BodyParser())
    
    router.all("/*", middleware: AllRemoteOriginMiddleware())
    
    /**
     Get all the todos
     */
    router.get("/") {
        request, response, next in
        
        todos.getAll() {
            todos in
            
            let json = JSON(TodoCollection.serialize(items: todos))
            do {
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Todo collection could not be serialized")
            }
            
        }
        
    }
    
    /**
     Get information about a todo item by ID
     */
    router.get(config.firstPathSegment + "/:id") {
        request, response, next in
        
        guard let id = request.params["id"] else {
            response.status(.badRequest)
            Log.error("Request does not contain ID")
            return
        }
        
        todos.get(id) {
            
            item in
            
            if let item = item {
                
                let result = JSON(item.serialize())
                
                do {
                    try response.status(.OK).send(json: result).end()
                } catch {
                    Log.error("Error sending response")
                }
            } else {
                Log.warning("Could not find the item")
                response.status(.badRequest)
                return
            }
            
        }
        
    }
    
    /**
     Handle options
     */
    router.options("/*") {
        request, response, next in
        
        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        response.headers["Access-Control-Allow-Methods"] =  "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH"
        
        response.status(.OK)
        
        next()
    }
    
    /**
     Add a todo list item
     */
    router.post("/") {
        request, response, next in
        
        guard let body = request.body else {
            response.status(.badRequest)
            return
        }
        
        guard case let .json(json) = body else {
            response.status(.badRequest)
            return
        }
        
        let name = json["name"].stringValue
        let detail = json["detail"].stringValue
        let completed = json["completed"].boolValue
        
        Log.info("Received \(name)")
        
        todos.add(name: name, detail: detail, completed: completed) {
            
            newItem in
            
            let result = JSON(newItem.serialize())
            
            do {
                try response.status(.OK).send(json: result).end()
            } catch {
                Log.error("Error sending response")
            }
            
        }
    }
    
    router.post(config.firstPathSegment + "/:id") {
        request, response, next in
        
        guard let id = request.params["id"] else {
            response.status(.badRequest)
            Log.error("id parameter not found in request")
            return
        }
        
        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Body is invalid JSON")
            return
        }
        
        let name = json["name"].stringValue
        let detail = json["detail"].stringValue
        let completed = json["completed"].boolValue
        
        todos.update(id: id, name: name, detail: detail, completed: completed) {
            
            newItem in
            
            let result = JSON(newItem!.serialize())
            
            response.status(.OK).send(json: result)
            
        }
        
    }
    
    /**
     Patch or update an existing Todo item
     */
    router.patch(config.firstPathSegment + "/:id") {
        request, response, next in
        
        guard let id = request.params["id"] else {
            response.status(.badRequest)
            Log.error("id parameter not found in request")
            return
        }
        
        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Body is invalid JSON")
            return
        }
        
        let name = json["name"].stringValue
        let detail = json["detail"].stringValue
        let completed = json["completed"].boolValue
        
        todos.update(id: id, name: name, detail: detail, completed: completed) {
            
            newItem in
            
            if let newItem = newItem {
                
                let result = JSON(newItem.serialize())
                
                do {
                    try response.status(.OK).send(json: result).end()
                } catch {
                    Log.error("Error sending response")
                }
            }
            
            
        }
    }
    
    ///
    /// Delete an individual todo item
    ///
    router.delete(config.firstPathSegment + "/:id") {
        request, response, next in
        
        Log.info("Requesting a delete")
        
        guard let id = request.params["id"] else {
            Log.warning("Could not parse ID")
            response.status(.badRequest)
            return
        }
        
        todos.delete(id) {
            
            do {
                try response.status(.OK).end()
            } catch {
                Log.error("Could not produce response")
            }
            
        }
        
    }
    
    /**
     Delete all the todo items
     */
    router.delete("/") {
        request, response, next in
        
        Log.info("Requested clearing the entire list")
        
        todos.clear() {
            do {
                try response.status(.OK).end()
            } catch {
                Log.error("Could not produce response")
            }
        }
        
        
    }
    
}
