//
//  UIProgressView+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

@IBDesignable
extension UIProgressView {
    @IBInspectable var barRadius: CGFloat {
        get {
            return (self.layer.sublayers?[1].cornerRadius)!
        }
        set {
            self.layer.sublayers?[1].cornerRadius = newValue
            self.subviews[1].clipsToBounds = true
        }
    }
}
