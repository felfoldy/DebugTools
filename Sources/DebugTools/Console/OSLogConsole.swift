//
//  OSLogConsole.swift
//
//
//  Created by Tibor Felföldy on 2024-05-08.
//

import Foundation
import OSLog
import Algorithms

public final class OSLogConsole: ObservableObject {
    var isStreaming = false
    @Published private(set) var logs = [LogModel]()
    
    private var store: OSLogStore
    private var subsystems: [String]
    
    init(subsystems: [String]) throws {
        store = try OSLogStore(scope: .currentProcessIdentifier)
        self.subsystems = subsystems
    }
    
    func fetchLogs() async throws {
        let predicate = NSPredicate(format: "subsystem IN %@", subsystems)
        
        let newEntries = try store.getEntries(matching: predicate)
            .compactMap { $0 as? OSLogEntryLog }
            .suffix(1000)
            .map(LogModel.init)
        
        let newResult = (logs + newEntries)
            .sorted { $0.date < $1.date }
            .uniqued(on: \.date)
        
        await MainActor.run {
            if logs != newResult {
                logs = newResult
            }
        }
    }

    func stream() async throws {
        isStreaming = true

        while isStreaming {
            try await fetchLogs()
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}
