//
//  ShareableModifier.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

@available(iOS 16.0, *)
struct ShareableModifier: ViewModifier {
    let log: [LogModel]
    
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: logsToShare) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                Button("Clear", systemImage: "trash") {
                    // TODO: Reimplement clear.
                }
            }
        }
    }
    
    private var logsToShare: String {
        log.map { entry in
            entry.composedMessage
        }
        .joined(separator: "\n")
    }
}

extension View {
    @ViewBuilder
    func shareable(log: [LogModel]) -> some View {
        if #available(iOS 16.0, *) {
            modifier(ShareableModifier(log: log))
        } else {
            self
        }
    }
}
