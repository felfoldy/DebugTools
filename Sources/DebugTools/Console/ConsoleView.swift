//
//  ConsoleView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

public struct ConsoleView: View {
    @ObservedObject private var console: ObservableConsole
    @State private var filterText = ""
    @Environment(\.dismiss) private var dismiss
    
    public init(console: any Console) {
        self.console = ObservableConsole(console: console)
    }
    
    public var body: some View {
        NavigationView {
            AutoScrollView(console: console) {
                LazyVStack(spacing: 0) {
                    ForEach(console.logs) { log in
                        LogView(log: log)
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
            DebugTools.isConsolePresented = true
        }
        .onDisappear {
            DebugTools.isConsolePresented = false
        }
    }

    private var filteredLogs: [LogEntry] {
        if filterText.isEmpty {
            return console.logs
        }
        
        return console.logs.filter { log in
            log.composedMessage.contains(filterText)
        }
    }
}
