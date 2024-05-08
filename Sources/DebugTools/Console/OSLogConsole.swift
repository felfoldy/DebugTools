//
//  OSLogConsole.swift
//
//
//  Created by Tibor Felföldy on 2024-05-08.
//

import Foundation
import OSLog

public final class OSLogConsole: ObservableObject {
    @Published private(set) var logs = [LogModel]()
    
    private var store: OSLogStore
    
    var isStreaming = false
    
    var subsystems: [String]
    
    init(subsystems: [String]) throws {
        store = try OSLogStore(scope: .currentProcessIdentifier)
        self.subsystems = subsystems
    }
    
    func fetchLogs() async throws {
        let predicate = NSPredicate(format: "subsystem IN %@", subsystems)
        
        let newEntries = try store.getEntries(matching: predicate)
            .compactMap { $0 as? OSLogEntryLog }
            .filter { $0.level != .undefined }
            .suffix(1000)
            .map(LogModel.init)
        
        await MainActor.run {
            logs = newEntries
        }
    }

    func stream() async throws {
        isStreaming = true

        while isStreaming {
            try await fetchLogs()
            try await Task.sleep(nanoseconds: 10)
        }
    }
}
