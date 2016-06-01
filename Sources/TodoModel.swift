
struct TodoModel {
    var id: String = ""
    var name: String = ""
    var detail: String = ""
    var completed: Bool = false
    
    func serialize() -> JSONDictionary {
        var result = JSONDictionary()
        result["id"] = id
        result["name"] = name
        result["detail"] = detail
        result["completed"] = completed
        return result
    }
}
































