import KituraSys
import SwiftyJSON
import Foundation

import LoggerAPI

class TodoCollection: TodoDAOProtocol {
    
    ///
    /// Ensure in order writes to the collection
    ///
    let writingQueue = Queue(type: .serial, label: "Writing Queue")
    
    ///
    /// Incrementing variable used for new index values
    ///
    var idCounter: Int = 0
    
    ///
    /// Internal storage of TodoModels as a Dictionary
    ///
    private var _collection = [String: TodoModel]()
    
    var count: Int {
        return _collection.keys.count
    }
    
    func clear( oncompletion: (Void) -> Void) {
        
        writingQueue.queueAsync() {
            self._collection.removeAll()
            oncompletion()
        }
        
    }
    
    func getAll( oncompletion: ([TodoModel]) -> Void ) {
        
        writingQueue.queueAsync() {
            oncompletion( [TodoModel](self._collection.values) )
        }
        
    }
    
    func get(_ id: String, oncompletion: (TodoModel?) -> Void ) {
        
        writingQueue.queueAsync() {
            oncompletion(self._collection[id])
        }
    }
    
    static func serialize(items: [TodoModel]) -> [JSONDictionary] {
        
        return items.map { $0.serialize() }
        
    }
    
    
    func add(name: String, description: String, completed: Bool = false, oncompletion: (TodoModel) -> Void ) {
        
        var original: String
        original = String(self.idCounter)
        
        let newItem = TodoModel(id: original,
                                name: name,
                                description: description,
                                completed: false        )
        
        writingQueue.queueAsync() {
            
            self.idCounter+=1
            
            self._collection[original] = newItem
            
            Log.info("Added \(name)")
            
            oncompletion(newItem)
            
        }
        
    }
    
    ///
    /// Update an element by id
    ///
    /// - Parameter id: id for the element
    /// -
    func update(id: String, name: String?, description: String?, completed: Bool?, oncompletion: (TodoModel?) -> Void ) {
        
        // search for element
        
        let oldValue = _collection[id]
        
        if let oldValue = oldValue {
            
            // use nil coalescing operator
            
            let newValue = TodoModel( id: id,
                                      name: name ?? oldValue.name,
                                      description: description ?? oldValue.description,
                                      completed: completed ?? oldValue.completed
            )
            
            writingQueue.queueAsync() {
                
                self._collection.updateValue(newValue, forKey: id)
                
                oncompletion( newValue )
            }
            
        } else {
            Log.warning("Could not find item in database with ID: \(id)")
        }
        
        
    }
    
    func delete(_ id: String, oncompletion: (Void) -> Void) {
        
        writingQueue.queueAsync() {
            
            self._collection.removeValue(forKey: id)
            oncompletion()
        }
        
    }
    
}




