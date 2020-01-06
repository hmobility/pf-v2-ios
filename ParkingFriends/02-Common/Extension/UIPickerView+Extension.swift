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
            return (self.subviews[0].subviews[1].backgroundColor)!
        }
        set {
            self.subviews[0].subviews[1].backgroundColor = newValue
            self.subviews[0].subviews[2].backgroundColor = newValue
        }
    }
    
    @IBInspectable var textLabelColor: UIColor? {
        get {
            return self.value(forKey: "textColor") as? UIColor
        }
        set {
            self.setValue(newValue, forKey: "textColor")
            self.performSelector(inBackground: Selector(("setHighlightsToday:")), with:newValue)
            /*
            self.subviews[0].subviews[3].setValue(newValue, forKey: "textColor")
            self.subviews[0].subviews[4].setValue(newValue, forKey: "textColor")
             */
        }
    }
}
