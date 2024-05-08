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
    
    func fetchLogs(since date: Date) async throws {
        let predicate = NSPredicate(format: "subsystem IN %@", subsystems)
        
        let position = store.position(date: date)
        
        let newEntries = try store.getEntries(at: position,
                                              matching: predicate)
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
        
        var lastFetchDate = Date()
        
        while isStreaming {
            if DebugTools.isConsolePresented {
                try await fetchLogs(since: lastFetchDate)
                lastFetchDate = Date()
            }
            try await Task.sleep(nanoseconds: 1_000_000)
        }
    }
}
