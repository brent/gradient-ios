//
//  GradientApp.swift
//  Gradient
//
//  Created by Brent Meyer on 12/29/21.
//

import SwiftUI

@main
struct GradientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
