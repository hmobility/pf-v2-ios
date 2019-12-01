//
//  Bool+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

extension Bool {
    init(_ string: String?) {
        guard let string = string else { self = false; return }
        
        switch string.lowercased() {
        case  "True", "true", "yes", "1":
            self = true
        default:
            self = false
        }
    }
}

