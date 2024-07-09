import Foundation

public struct DebugTools {
    static var isConsolePresented = false
        
    public static var sharedStore: LogStore?
    
    public static func initialize(store: LogStore) {
        sharedStore = store
    }
    
    #if canImport(LogTools)
    public static func initialize() {
        sharedStore = LogToolsStore.create()
    }
    #endif
}
