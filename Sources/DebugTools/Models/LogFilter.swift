//
//  LogFilter.swift
//
//
//  Created by Tibor Felföldy on 2024-06-14.
//

import Foundation

public protocol LogFilter {
    func apply(logs: [any PresentableLog]) -> [any PresentableLog]
}

// MARK: - none

public struct NoFilter: LogFilter {
    public func apply(logs: [any PresentableLog]) -> [any PresentableLog] {
        logs
    }
}

public extension LogFilter where Self == NoFilter {
    static var `none`: NoFilter {
        NoFilter()
    }
}
