//
//  UINavigationController+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/10.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open var rootViewController: UIViewController? {
        get {
            viewControllers.first
        }
        set {
            var rvc: [UIViewController] = []
            if let vc = newValue {
                rvc = [vc]
            }
            setViewControllers(rvc, animated: false)
        }
    }
    
    public convenience init(rootViewController: UIViewController, navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        self.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.rootViewController = rootViewController
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let viewController = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(viewController, animated: animated)
        }
    }
}
