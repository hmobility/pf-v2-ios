//
//  IconType.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

public enum IconType: String {
    case warning = "icWarningFillCircleRed"
    case success = "icSuccessGreen"
    case notice = "icCheckOn"
    
    public var image: UIImage {
        return UIImage(named: rawValue)!
    }
}

