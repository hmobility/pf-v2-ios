//
//  UIStoryboard+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension UIViewController {
    class var storyboardId: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardId) as? T else {
            fatalError("Cast error to \(T.self)")
        }
        return viewController
    }
}
