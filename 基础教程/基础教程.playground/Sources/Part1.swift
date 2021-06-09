import Foundation

public struct Actor {
    private(set) var name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public func getName() -> String {
        return name
    }
}
