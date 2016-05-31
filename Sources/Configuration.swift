import Foundation
import CFEnvironment

public struct Configuration {
    
    let port: Int?
    let url: String?
    let firstPathSegment = "todos"
    init() {
        do {
            let appEnv = try CFEnvironment.getAppEnv()
            port = appEnv.port
            url = appEnv.url
        }
        catch _ {
            port = nil
            url = nil
        }
    }
}
































