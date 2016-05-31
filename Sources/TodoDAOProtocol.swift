#if os(OSX)
    typealias JSONDictionary = [String: AnyObject]
#else
    typealias JSONDictionary = [String: Any]
#endif

/// DAO protocol

protocol TodoDAOProtocol {
    
    var count: Int { get }
    
    func clear(oncompletion: (Void) -> Void)
    
    func getAll(oncompletion: ([TodoModel]) -> Void )
    
    func get(_ id: String, oncompletion: (TodoModel?) -> Void )
    
    func add(name: String, description: String, completed: Bool, oncompletion: (TodoModel) -> Void )
    
    func update(id: String, name: String?, description: String?, completed: Bool?, oncompletion: (TodoModel?) -> Void )
    
    func delete(_ id: String, oncompletion: (Void) -> Void)
    
    static func serialize(items: [TodoModel]) -> [JSONDictionary]
    
}