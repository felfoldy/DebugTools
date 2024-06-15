//
//  LogEntry.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import Foundation
import OSLog

public struct LogEntry: PresentableLog {
    let subsystem: String?
    let category: String?
    let composedMessage: String
    let level: OSLogEntryLog.Level
    let date: Date
    let location: String
}

extension LogEntry: Equatable {
    public var id: String { "\(location)\(date.timeIntervalSince1970)" }
}
