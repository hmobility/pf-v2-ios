//
//  UINavigationController+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/10.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let viewController = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(viewController, animated: animated)
        }
    }
}
