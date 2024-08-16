//
//  UIWindow+Shake.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

#if canImport(UIKit)
import UIKit
import SwiftUI

extension UIWindow {
    public static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if rootViewController?.topMostViewController is ConsoleViewController {
            return
        }
        
        guard motion == .motionShake else { return }

        showConsole()
    }
    
    public func showConsole() {
        guard let consoleView = DebugTools.shakePresentedConsole?() else {
            return
        }
        
        rootViewController?.topMostViewController
            .present(consoleView, animated: true)
    }
}

public extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}
#endif
