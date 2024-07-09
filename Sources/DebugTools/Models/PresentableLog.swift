//
//  PresentableLog.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-14.
//

import Foundation

public protocol PresentableLog: Identifiable, Equatable {
    var id: String { get }
}

public extension PresentableLog {
    var id: String { String(describing: self) }
}

public protocol SortableLog: PresentableLog {
    var date: Date { get }
}
