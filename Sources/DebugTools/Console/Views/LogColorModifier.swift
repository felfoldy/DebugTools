//
//  LogColorModifier.swift
//
//
//  Created by Tibor Felföldy on 2024-06-10.
//

import SwiftUI

struct LogColorModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        HStack {
            if #available(iOS 16.0, *) {
                Capsule()
                    .fill(color.gradient)
                    .frame(width: 4)
            }
            
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(4)
        .background {
            color.opacity(0.1)
        }
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

extension View {
    func logColor(_ color: Color) -> some View {
        modifier(LogColorModifier(color: color))
    }
}

#Preview {
    ScrollView {
        Text("Some log")
            .logColor(.blue)
    }
}
