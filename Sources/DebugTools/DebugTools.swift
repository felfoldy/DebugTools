import Foundation

#if canImport(UIKit)
import UIKit
#endif

public struct DebugTools {    
    public static var sharedStore: LogStore?
    
    #if canImport(UIKit)
    /// A console presented by a shake gesture on iOS.
    public static var shakePresentedConsole: ConsoleProvider? = defaultConsoleProvider
    #endif
    
    public static func initialize(store: LogStore? = nil) {
        sharedStore = store ?? LogToolsStore.create()
    }
    
    public static func showConsole() {
        #if canImport(UIKit)
        UIWindow.keyWindow?.showConsole()
        #else
        // TODO: Solve it for app kit?
        #endif
    }
}
