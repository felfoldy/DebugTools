//
//  ShareableModifier.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

@available(iOS 16.0, *)
struct ShareableModifier: ViewModifier {
    let log: [LogEntry]
    
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: logsToShare) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                Button("Clear", systemImage: "trash") {
                    DebugToolsConsole.shared.logs = []
                }
            }
        }
    }
    
    private var logsToShare: String {
        log.map { entry in
            switch entry.content {
            case let .message(content):
                content.formatted
            }
        }
        .joined(separator: "\n")
    }
}

extension View {
    @ViewBuilder
    func shareable(log: [LogEntry]) -> some View {
        if #available(iOS 16.0, *) {
            modifier(ShareableModifier(log: log))
        } else {
            self
        }
    }
}
