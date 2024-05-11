//
//  OSLogConsole.swift
//
//
//  Created by Tibor Felföldy on 2024-05-08.
//

import Foundation
import OSLog
import Combine

public final class OSLogConsole: Console {
    var isStreaming = false
    
    public var updateLogPublisher = PassthroughSubject<[LogEntry], Never>()
    
    private var store: OSLogStore
    private var subsystems: [String]
    
    public init(subsystems: [String]) throws {
        store = try OSLogStore(scope: .currentProcessIdentifier)
        self.subsystems = subsystems
    }

    public func stream() async throws {
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
    
    func fetchLogs(since date: Date) async throws {
        let predicate = NSPredicate(format: "subsystem IN %@", subsystems)
        
        let position = store.position(date: date)
        
        let newEntries = try store.getEntries(at: position,
                                              matching: predicate)
            .compactMap { $0 as? OSLogEntryLog }
            .suffix(1000)
            .map(LogEntry.init)
        
        await MainActor.run {
            updateLogPublisher.send(newEntries)
        }
    }
}
