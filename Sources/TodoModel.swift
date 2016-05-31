
struct TodoModel {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var completed: Bool = false
    
    func serialize() -> JSONDictionary {
        var result = JSONDictionary()
        result["id"] = id
        result["name"] = name
        result["description"] = description
        result["completed"] = completed
        return result
    }
}
































