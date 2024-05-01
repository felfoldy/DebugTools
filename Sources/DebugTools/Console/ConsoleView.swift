//
//  ConsoleView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

public struct ConsoleView: View {
    @ObservedObject private var console = DebugToolsConsole.shared
    @State private var filterText = ""
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            AutoScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredLogs) { log in
                        LogView(entry: log)
                    }
                }
            }
            .searchable(text: $filterText, prompt: "filter")
            .navigationTitle("Console")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark.circle") {
                        dismiss()
                    }
                }
            }
            .shareable(log: filteredLogs)
        }
        .onAppear {
            console.isPresented = true
        }
        .onDisappear {
            console.isPresented = false
        }
    }

    private var filteredLogs: [LogEntry] {
        if filterText.isEmpty {
            return console.logs
        }
        
        return console.logs.filter { entry in
            switch entry.content {
            case let .message(content):
                content.message
                    .lowercased()
                    .contains(filterText.lowercased())
            }
        }
    }
}

#Preview {
    VStack {
        ConsoleView()
        
        Button("Log") {
            _ = DebugToolsConsole.shared
                .send(.warning,
                      msg: "Ohh no!", thread: "main", file: #file, function: #function, line: #line)
        }
    }
}
