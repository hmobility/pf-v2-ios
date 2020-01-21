//
//  NavigationBar.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/20.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class TransparentNavigationBar: UINavigationBar {
    @IBInspectable var transparentBackground: Bool = false {
        didSet {
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
            self.isTranslucent = true
        }
    }
}
