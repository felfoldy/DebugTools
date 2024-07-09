//
//  LogEntryView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI
import OSLog

struct LogEntryView: View {
    let log: LogEntry
    
    var body: some View {
        LogContainerView(tint: tint) {
            VStack(alignment: .leading) {
                HStack {
                    Text(log.location)
                    
                    Spacer()
                    
                    Text(log.date.formatted(date: .omitted,
                                            time: .standard))
                }
                .font(.caption2)
                .foregroundColor(.secondary)

                Text(log.composedMessage)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                
                if let subsystem = log.subsystem, let category = log.category {
                    HStack {
                        Label(subsystem, systemImage: "gearshape.2")
                        Label(category, systemImage: "circle.grid.3x3")
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }
        }
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
        subsystem = "com.felfoldy.DebugTools"
        category = "Default"
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
            LogEntryView(log: log(.debug))
            LogEntryView(log: log(.info))
            LogEntryView(log: log(.notice))
            LogEntryView(log: log(.error))
            LogEntryView(log: log(.fault))
            LogEntryView(log: log(.undefined))
        }
    }
}
