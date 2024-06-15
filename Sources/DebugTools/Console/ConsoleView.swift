//
//  ConsoleView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

public struct ConsoleView: View {
    @ObservedObject var store: LogStore

    @State private var filterText = ""
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationView {
            AutoScrollView(store: store) {
                LazyVStack(spacing: 0) {
                    ForEach(store.logs, id: \.id) { log in
                        if let entry = log as? LogEntry {
                            LogEntryView(log: entry)
                        }
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
        }
        .onAppear {
            DebugTools.isConsolePresented = true
        }
        .onDisappear {
            DebugTools.isConsolePresented = false
        }
    }
}
