//
//  DebugToolsConsole.swift
//
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import Foundation
import SwiftyBeaver

final class DebugToolsConsole: BaseDestination, ObservableObject {
    static let shared = DebugToolsConsole()
    
    @Published private(set) var logs = [LogEntry]()
    
    override func send(_ level: SwiftyBeaver.Level, msg: String, thread: String, file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)
        guard let formattedString,
              let url = URL(string: file) else {
            return nil
        }
                
        let path = url
            .deletingPathExtension()
            .lastPathComponent
        
        let message = LogMessage(
            level: level,
            location: "\(path).\(function):\(line)",
            message: msg
        )
        
        let entry = LogEntry(content: .message(message))
        
        DispatchQueue.main.async {
            self.logs.append(entry)
        }

        return formattedString
    }
}
