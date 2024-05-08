import Foundation

public struct DebugTools {
    static var isConsolePresented = false
        
    static var sharedConsole: OSLogConsole?
    
    public static func startStreaming(subsystems: [String]? = nil) async throws {
        let console = try OSLogConsole(subsystems: subsystems ?? defaultSubsystems)
        sharedConsole = console

        try await console.stream()
    }
    
    private static var defaultSubsystems: [String] {
        var subsystems = [
            "Default",
            "com.apple.coredata",
            "com.apple.ttsasset"
        ]
        
        if let identifier = Bundle.main.bundleIdentifier {
            subsystems.append(identifier)
        }
        
        return subsystems
    }
}
