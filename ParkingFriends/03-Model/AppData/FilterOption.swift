//
//  FilterOption.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/10.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

typealias FilterType = (fee:(from:Int, to:Int), sortType:FilterSortType, operationType:FilterOperationType, areaType:FilterAreaType, option:(cctv:Bool, iotSensor:Bool, mechanical:Bool, allDay:Bool))

// FilterType 용
enum FilterSortType: Int {
    case low_price, nearby
    
    var param: String {
        switch self {
        case .low_price:
            return SortType.price.rawValue
        case .nearby:
            return SortType.distance.rawValue
        }
    }
}

enum FilterOperationType: Int {
    case none, public_area, private_area
    
    var param: String {
        switch self {
        case .none:
            return ""
        case .public_area:
            return ProductType.public_lot.rawValue
        case .private_area:
            return ProductType.private_lot.rawValue
        }
    }
}

enum FilterAreaType: Int {
    case none, indoor, outdoor
}

class FilterOption: NSObject, NSCoding {
    var from:Int = 0
    var to:Int = 10000
    var sortType:FilterSortType = .low_price
    var operationType:FilterOperationType = .none
    var areaType:FilterAreaType = .none
    var isCCTV:Bool = false
    var isIotSensor:Bool = false
    var isNoMechanical:Bool = false
    var isAllDay:Bool = false

    var filter:FilterType {
        get {
            return FilterType (fee:(from:from, to:to), sortType:sortType, operationType:operationType, areaType:areaType, option:(cctv:isCCTV, iotSensor:isIotSensor, mechanical:isNoMechanical, allDay:isAllDay))
        }
    }
    
    override init() {
    }

    required init(coder aDecoder: NSCoder) {
        from = aDecoder.decodeObject(forKey: "from") as! Int
        to = aDecoder.decodeObject(forKey: "to") as! Int
        sortType = FilterSortType(rawValue: aDecoder.decodeObject(forKey: "sortType") as! Int) ?? .low_price // as! FilterSortType
        operationType = aDecoder.decodeObject(forKey: "operationType") as! FilterOperationType
        areaType = aDecoder.decodeObject(forKey: "areaType") as! FilterAreaType
        isCCTV = aDecoder.decodeObject(forKey: "isCCTV") as! Bool
        isIotSensor = aDecoder.decodeObject(forKey: "isIotSensor") as! Bool
        isNoMechanical = aDecoder.decodeObject(forKey: "isNoMechanical") as! Bool
        isAllDay = aDecoder.decodeObject(forKey: "isAllDay") as! Bool
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(from, forKey: "from")
        aCoder.encode(to, forKey: "to")
        aCoder.encode(sortType.rawValue, forKey: "sortType")
        aCoder.encode(operationType.rawValue, forKey: "operationType")
        aCoder.encode(areaType.rawValue, forKey: "areaType")
        aCoder.encode(isCCTV, forKey: "isCCTV")
        aCoder.encode(isIotSensor, forKey: "isIotSensor")
        aCoder.encode(isNoMechanical, forKey: "isNoMechanical")
        aCoder.encode(isAllDay, forKey: "isAllDay")
    }
}
