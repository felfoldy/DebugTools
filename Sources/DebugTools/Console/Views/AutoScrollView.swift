//
//  AutoScrollView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

struct AutoScrollView<Content: View>: View {
    let store: LogStore
    let content: () -> Content
        
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                content()
                
                Spacer(minLength: 8)
                    .id("bottom")
            }
            .onChange(of: store.filterredLogs.map(\.id)) { _ in
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
