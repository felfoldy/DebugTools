//
//  LogEntry.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import Foundation
import OSLog

struct LogModel {
    let composedMessage: String
    let level: OSLogEntryLog.Level
    let date: Date
    let location: String
}

extension LogModel {
    init(logEntry: OSLogEntryLog) {
        composedMessage = logEntry.composedMessage
        level = logEntry.level
        date = logEntry.date
        location = "\(logEntry.sender) \(logEntry.process)"
    }
}

extension LogModel: Identifiable {
    var id: String { "\(location)\(date.timeIntervalSince1970)" }
}
