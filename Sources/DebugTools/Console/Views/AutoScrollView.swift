//
//  AutoScrollView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

struct AutoScrollView<Content: View>: View {
    let content: () -> Content
    
    private let console = DebugToolsConsole.shared
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                content()
                
                Spacer(minLength: 8)
                    .id("bottom")
            }
            .onReceive(console.objectWillChange) {
                withAnimation {
                    proxy.scrollTo("bottom")
                }
            }
            .onAppear {
                proxy.scrollTo("bottom")
            }
        }
    }
}
