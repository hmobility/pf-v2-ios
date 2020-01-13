//
//  UIPickerView+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

@IBDesignable
extension UIPickerView {
    @IBInspectable var indicatorColor: UIColor? {
        get {
            return (self.subviews[1].backgroundColor)!
        }
        set {
            self.subviews[1].backgroundColor = newValue
            self.subviews[2].backgroundColor = newValue
        }
    }
    
    @IBInspectable var textLabelColor: UIColor? {
        get {
            return self.value(forKey: "textColor") as? UIColor
        }
        set {
            self.setValue(newValue, forKey: "textColor")
            self.performSelector(inBackground: Selector(("setHighlightsToday:")), with: newValue)
        }
    }
}
