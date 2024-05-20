//
//  Console.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-10.
//

import Foundation
import Combine

public protocol Console {
    var updateLogPublisher: CurrentValueSubject<[LogEntry], Never> { get }
}

class ObservableConsole: ObservableObject {
    @Published var logs: [LogEntry] = []

    private var console: any Console

    init(console: any Console) {
        self.console = console
        
        console.updateLogPublisher.assign(to: &$logs)
    }
}
