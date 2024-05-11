//
//  LogEntry.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import Foundation
import OSLog

public struct LogEntry {
    let composedMessage: String
    let level: OSLogEntryLog.Level
    let date: Date
    let location: String
}

extension LogEntry {
    init(logEntry: OSLogEntryLog) {
        composedMessage = logEntry.composedMessage
        level = logEntry.level
        date = logEntry.date
        location = "\(logEntry.sender) \(logEntry.process)"
    }
}

extension LogEntry: Identifiable, Equatable {
    public var id: String { "\(location)\(date.timeIntervalSince1970)" }
}
