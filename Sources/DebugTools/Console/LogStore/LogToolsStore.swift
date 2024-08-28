//
//  LogToolsStore.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-15.
//

import LogTools
import OSLog

final class LogToolsStore: LogStore, LogDestination {
    static func create() -> LogToolsStore {
        let destination = LogToolsStore(logFilter: .none)
        Logger.destinations.append(destination)
        return destination
    }
    
    func log(subsystem: String?, category: String?, level: OSLogType, _ message: String, file: String, function: String, line: Int) {
        guard let url = URL(string: file) else {
            return
        }
        
        let level: OSLogEntryLog.Level = {
            switch level {
            case .debug: .debug
            case .default: .notice
            case .info: .info
            case .error: .error
            case .fault: .fault
            default: .undefined
            }
        }()
        
        let path = url.deletingPathExtension().lastPathComponent
        let location = "\(path).\(function):\(line)"
        
        let entry = LogEntry(subsystem: subsystem,
                              category: category,
                              message: message,
                              level: level,
                              location: location)

        logs.append(entry)
    }
}
