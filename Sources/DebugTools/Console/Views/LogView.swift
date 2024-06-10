//
//  LogView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI
import OSLog

struct LogView: View {
    let log: LogEntry
    
    var body: some View {
        VStack {
            HStack {
                Text(log.location)
                
                Spacer()
                
                Text(
                    log.date.formatted(date: .omitted,
                                       time: .standard)
                )
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            
            Text(log.composedMessage)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
        }
        .logColor(tint)
    }
    
    private var tint: Color {
        switch log.level {
        case .info: .cyan
        case .debug: .green
        case .notice: .yellow
        case .error: .orange
        case .fault: .red
        case .undefined: .clear
        @unknown default: .clear
        }
    }
}

private extension LogEntry {
    init(message: String, level: OSLogEntryLog.Level) {
        composedMessage = message
        self.level = level
        date = .now
        location = "location"
    }
}

#Preview {
    func log(_ level: OSLogEntryLog.Level) -> LogEntry {
        LogEntry(message: String(describing: level), level: level)
    }
    
    return ScrollView {
        VStack(spacing: 0) {
            LogView(log: log(.debug))
            LogView(log: log(.info))
            LogView(log: log(.notice))
            LogView(log: log(.error))
            LogView(log: log(.fault))
        }
    }
}
