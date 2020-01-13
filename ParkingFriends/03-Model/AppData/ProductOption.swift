//
//  ProductOption.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/17.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class ProductOption: NSObject, NSCoding {
    var monthlyFrom:Int = 0
    var monthlyCount:Int = 0
    
    var selectedProductType:ProductType = .fixed
    
    var reservableStartTime: Date  {
        get {
            return start ?? today
        }
    }
    
    var reservableEndTime: Date {
        get {
            return end ?? today.adjust(.hour, offset: 2)
        }
    }
    
    var start: Date?
    var end: Date?
    
    private var today: Date {
        get {
            var start = Date().dateFor(.nearestMinute(minute:10))
            
            if Date().compare(.isLater(than: start)) == true {
                start = start.adjust(.minute, offset: 10)
            }
            
            return start
        }
    }
    
    // MARK: - Initialize

    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
     //   monthlyFrom = aDecoder.decodeObject(forKey: "monthlyFrom") as? Int ?? 0
     //   monthlyCount = aDecoder.decodeObject(forKey: "monthlyCount") as? Int ?? 0
        selectedProductType = ProductType(rawValue: aDecoder.decodeObject(forKey: "selectedProductType") as! String) ?? .fixed
    }

    func encode(with aCoder: NSCoder) {
       // aCoder.encode(monthlyFrom, forKey: "monthlyFrom")
      //  aCoder.encode(monthlyCount, forKey: "monthlyCount")
        aCoder.encode(selectedProductType.rawValue, forKey: "selectedProductType")
    }
}
