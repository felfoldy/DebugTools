//
//  ConsoleView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

struct ConsoleView: View {
    @ObservedObject private var console = DebugToolsConsole.shared
    
    @State private var filterText = ""
    
    var body: some View {
        NavigationView {
            SearchableView {
                AutoScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredLogs) { log in
                            LogView(entry: log)
                        }
                    }
                }
            }
            .navigationTitle("Console")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func SearchableView<Content: View>(content: () -> Content) -> some View {
        if #available(iOS 15.0, *) {
            content()
                .searchable(text: $filterText, prompt: "filter")
        } else {
            content()
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
