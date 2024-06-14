import Foundation

public struct DebugTools {
    static var isConsolePresented = false
        
    static var sharedStore: LogStore?
    
    public static func initialize(store: LogStore) {
        sharedStore = store
    }
}
