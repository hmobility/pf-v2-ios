//
//  Date+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/27.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

// use this extension to calculate Time Band in Parkinglot Detail
extension Date {
    var hours:Double {
        get {
            let calendar = Calendar.current
            let hours = calendar.component(.hour, from: self)
            let minutes = calendar.component(.minute, from: self)
            
            return Double(hours + (minutes / 60))
        }
    }
    
    var withoutTimeStamp:Date {
        get {
            guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
                fatalError("Failed to strip time from Date object")
            }
            return date
        }
    }
}
