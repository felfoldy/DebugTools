//
//  LogEntry.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import Foundation
import OSLog

public struct LogEntry: PresentableLog, SortableLog {
    public let subsystem: String?
    public let category: String?
    public let composedMessage: String
    public let level: OSLogEntryLog.Level
    public let date: Date
    public let location: String
    
    public init(subsystem: String? = nil, category: String? = nil, message: String, level: OSLogEntryLog.Level, date: Date = Date(), location: String) {
        self.subsystem = subsystem
        self.category = category
        self.composedMessage = message
        self.level = level
        self.date = date
        self.location = location
    }
}

extension LogEntry: Equatable {
    public var id: String { "\(location)\(date.timeIntervalSince1970)" }
}
