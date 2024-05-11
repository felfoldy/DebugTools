//
//  Console.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-10.
//

import Foundation

public protocol Console: ObservableObject {
    var logs: [LogEntry] { get }
}
