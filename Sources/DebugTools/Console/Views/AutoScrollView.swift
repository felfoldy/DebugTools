//
//  AutoScrollView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

struct AutoScrollView<ConsoleModel: Console, Content: View>: View {
    let console: ConsoleModel
    let content: () -> Content
        
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                content()
                
                Spacer(minLength: 8)
                    .id("bottom")
            }
            .onReceive(console.objectWillChange) { _ in 
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
