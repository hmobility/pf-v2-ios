//
//  ProductOption.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/17.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import AFDateHelper

class ProductOption: NSObject, NSCoding {
    var radius:Int = 0
    var monthlyFrom:Int = 0
    var monthlyCount:Int = 0
    var sort:SortType = .distance
    
    var selectedProductType:ProductType = .fixed
    
    var start:String {
        get {
            return Date().dateFor(.nearestHour(hour:1)).toString(format: .custom("HHmm"))
           //return Date().dateRoundedAt(at:.toCeilMins(60)).toString(format: "HHmm")
        }
    }
    
    var end:String {
        get {
            return Date().dateFor(.nearestHour(hour:1)).adjust(.hour, offset: +2).toString(format: .custom("HHmm"))
        }
    }
    
    override init() {
    }

    required init(coder aDecoder: NSCoder) {
        radius = aDecoder.decodeObject(forKey: "radius") as? Int ?? 15
       // start = aDecoder.decodeObject(forKey: "start") as? NSDate ?? 15
       // end = aDecoder.decodeObject(forKey: "end") as? NSDate ?? 15
        monthlyFrom = aDecoder.decodeObject(forKey: "radius") as? Int ?? 0
        monthlyCount = aDecoder.decodeObject(forKey: "radius") as? Int ?? 0
        sort = aDecoder.decodeObject(forKey: "radius") as? SortType ?? .distance
        selectedProductType = aDecoder.decodeObject(forKey: "selectedProductType") as? ProductType ?? .fixed
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(radius, forKey: "radius")
        aCoder.encode(radius, forKey: "monthlyFrom")
        aCoder.encode(radius, forKey: "monthlyCount")
        aCoder.encode(radius, forKey: "sort")
        aCoder.encode(selectedProductType, forKey: "selectedProductType")
    }
}
