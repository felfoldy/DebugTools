//
//  LogStore.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-14.
//

import Foundation

open class LogStore: ObservableObject {
    @Published public var logs = [any PresentableLog]()
    @Published public var logFilter: any LogFilter = .none
    
    var filterredLogs: [any PresentableLog] {
        logFilter.apply(logs: logs)
    }
}
