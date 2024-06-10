//
//  NetworkLogView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-20.
//

import SwiftUI

struct NetworkLogView: View {
    let task: TaskInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("requesting", systemImage: "globe")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(
                    task.date.formatted(date: .omitted,
                                        time: .standard)
                )
                .foregroundColor(.secondary)
            }
            .font(.caption2)
            
            Text(task.request.description)
            
            HStack {
                Text(task.request.httpMethod ?? "GET")
                
                Text("\(Image(systemName: "arrowshape.up.fill")) \(uploadDataCount.formatted(.byteCount(style: .memory, spellsOutZero: false)))")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .logColor(.teal)
    }
    
    private var uploadDataCount: Int64 {
        Int64(task.request.httpBody?.count ?? 0)
    }
}

#Preview {
    ScrollView {
        NetworkLogView(task: TaskInfo(request: URLRequest(url: URL(string: "http://www.example.com/index.html")!), response: nil, data: nil, error: nil, metrics: nil))
    }
}
