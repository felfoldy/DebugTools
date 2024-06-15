//
//  DebugToolsConsoleDestination.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-11.
//

#if canImport(SwiftyBeaver)
import Foundation
import SwiftyBeaver
import Combine
import OSLog

public final class DebugToolsConsoleDestination: ConsoleDestination {
    public let store = LogStore()
    
    public override func send(_ level: SwiftyBeaver.Level, msg: String, thread: String, file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let formatted = super.send(level, msg: msg, thread: thread,
                                   file: file, function: function,
                                   line: line, context: context)
        
        let path = URL(string: file)?.deletingPathExtension().lastPathComponent
        
        guard let formatted, let path else {
            return nil
        }

        let level: OSLogEntryLog.Level = switch level {
        case .verbose, .debug: .debug
        case .info: .info
        case .warning, .error: .error
        case .critical, .fault: .fault
        }
        
        let location = "\(path).\(function):\(line)"
        
        let entry = LogEntry(subsystem: nil,
                             category: nil,
                             composedMessage: msg,
                             level: level,
                             date: .now,
                             location: location)
        
        store.logs.append(entry)

        return formatted
    }
}
#endif
