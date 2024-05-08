//
//  LogView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI
import OSLog

struct LogView: View {
    let log: LogModel
    
    var body: some View {
        HStack {
            if #available(iOS 16.0, *) {
                Capsule()
                    .fill(tint.gradient)
                    .frame(width: 4)
            }
            
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
        }
        .padding(4)
        .overlay(alignment: .bottom) {
            Divider()
        }
        .background {
            tint.opacity(0.1)
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

private extension LogModel {
    init(message: String, level: OSLogEntryLog.Level) {
        composedMessage = message
        self.level = level
        date = .now
        location = "location"
    }
}

#Preview {
    func log(_ level: OSLogEntryLog.Level) -> LogModel {
        LogModel(message: String(describing: level), level: level)
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
