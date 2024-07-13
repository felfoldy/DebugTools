import Foundation

public struct DebugTools {
    static var isConsolePresented = false
    
    public static var sharedStore: LogStore?
    
    #if canImport(UIKit)
    /// A console presented by a shake gesture on iOS.
    public static var shakePresentedConsole: ConsoleProvider? = defaultConsoleProvider
    #endif
    
    public static func initialize(store: LogStore) {
        sharedStore = store
    }
    
    #if canImport(LogTools)
    public static func initialize() {
        sharedStore = LogToolsStore.create()
    }
    #endif
}
