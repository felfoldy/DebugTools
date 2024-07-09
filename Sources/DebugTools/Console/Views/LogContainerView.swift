//
//  LogContainerView.swift
//  
//
//  Created by Tibor Felföldy on 2024-07-09.
//

import SwiftUI

public struct LogContainerView<Content: View>: View {
    let tint: Color
    let content: () -> Content
    
    public init(tint: Color, @ViewBuilder content: @escaping () -> Content) {
        self.tint = tint
        self.content = content
    }
    
    public var body: some View {
        HStack {
            if #available(iOS 16.0, *) {
                Capsule()
                    .fill(tint.gradient)
                    .frame(width: 4)
            }
            
            content()
        }
        .padding(4)
        .overlay(alignment: .bottom) {
            Divider()
        }
        .background {
            tint.opacity(0.1)
        }
    }
}

#Preview {
    ScrollView {
        LogContainerView(tint: .orange) {
            Text("Content").frame(width: 200)
        }
        
        LogContainerView(tint: .purple) {
            Text("purple").frame(width: 200)
        }
        
        LogContainerView(tint: .green) {
            Text("green").frame(width: 200)
        }
    }
}
