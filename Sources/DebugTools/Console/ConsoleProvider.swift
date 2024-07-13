//
//  ConsoleProvider.swift
//  DebugTools
//
//  Created by Tibor Felföldy on 2024-07-13.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

public typealias ConsoleProvider = () -> UIViewController?

public let defaultConsoleProvider: ConsoleProvider = {
    guard let store = DebugTools.sharedStore else {
        return nil
    }
    
    let navigationView = ConsoleNavigationView(store: store)
    
    return UIHostingController(rootView: navigationView)
}
#endif
