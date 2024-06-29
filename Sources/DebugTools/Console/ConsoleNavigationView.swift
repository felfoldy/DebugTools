//
//  ConsoleNavigationView.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-29.
//

import SwiftUI

struct ConsoleNavigationView: View {
    @ObservedObject var store: LogStore

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ConsoleView(store: store)
                .navigationTitle("Console")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark.circle") {
                            dismiss()
                        }
                    }
                }
                #endif
        }
        .onAppear {
            DebugTools.isConsolePresented = true
        }
        .onDisappear {
            DebugTools.isConsolePresented = false
        }
    }
}
