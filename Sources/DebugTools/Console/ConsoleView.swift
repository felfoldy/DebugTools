//
//  ConsoleView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

public struct ConsoleView: View {
    @ObservedObject private var console: OSLogConsole
    @State private var filterText = ""
    @Environment(\.dismiss) private var dismiss
    
    public init(console: OSLogConsole) {
        self.console = console
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

    private var filteredLogs: [LogModel] {
        if filterText.isEmpty {
            return console.logs
        }
        
        return console.logs.filter { log in
            log.composedMessage.contains(filterText)
        }
    }
}

import OSLog

#Preview {
    VStack {
        ConsoleView(console: {
            let id = Bundle.main.bundleIdentifier!
            let console = try! OSLogConsole(subsystems: [id])
            
            Task {
                try await console.stream()
            }
                        
            return console
        }())
        
        Button("Log") {
            let identifier = Bundle.main.bundleIdentifier!
            let log = Logger(subsystem: identifier,
              category: "AppModel")
                        
            log.error("Some log message")
        }
    }
}
