import Foundation

public struct DebugTools {    
    public static var sharedStore: LogStore?
    
    #if canImport(UIKit)
    /// A console presented by a shake gesture on iOS.
    public static var shakePresentedConsole: ConsoleProvider? = defaultConsoleProvider
    #endif
    
    public static func initialize(store: LogStore? = nil) {
        #if canImport(LogTools)
        sharedStore = store ?? LogToolsStore.create()
        #else
        sharedStore = store
        #endif
    }
}
