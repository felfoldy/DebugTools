//
//  LogView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI
import SwiftyBeaver

struct LogView: View {
    let entry: LogEntry
    
    var body: some View {
        HStack {
            if #available(iOS 16.0, *) {
                Capsule()
                    .fill(tint.gradient)
                    .frame(width: 4)
            }
            
            VStack {
                HStack {
                    if case let .message(content) = entry.content {
                        Text(content.location)
                    }
                    
                    Spacer()
                    
                    Text(
                        entry.date.formatted(date: .omitted,
                                             time: .standard)
                    )
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                
                switch entry.content {
                case let .message(content):
                    Text(content.message)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
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
        switch entry.content {
        case let .message(content):
            switch content.level {
            case .verbose: .mint
            case .info: .cyan
            case .debug: .green
            case .warning: .yellow
            case .fault, .critical, .error: .red
            }
        }
    }
}

#Preview {
    func log(_ level: SwiftyBeaver.Level) -> LogEntry {
        LogEntry(content: .message(
            LogMessage(level: level,
                       location: "SomeFile.func():10",
                       message: String(describing: level))
        ))
    }
    
    return ScrollView {
        VStack(spacing: 0) {
            LogView(entry: log(.verbose))
            LogView(entry: log(.info))
            LogView(entry: log(.debug))
            LogView(entry: log(.warning))
            LogView(entry: log(.error))
            LogView(entry: log(.fault))
            LogView(entry: log(.critical))
        }
    }
}
