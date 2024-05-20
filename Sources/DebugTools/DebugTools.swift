import Foundation

public struct DebugTools {
    static var isConsolePresented = false
    static var sharedConsole: (any Console)?
    
    public static func initialize(console: any Console) {
        sharedConsole = console
    }
}
