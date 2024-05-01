//
//  LogEntry.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import Foundation
import SwiftyBeaver

struct LogEntry: Identifiable {
    let content: LogContent
    
    let id = UUID()
    let date = Date()
}

enum LogContent {
    case message(LogMessage)
}

struct LogMessage {
    let level: SwiftyBeaver.Level
    let location: String
    let message: String
}
