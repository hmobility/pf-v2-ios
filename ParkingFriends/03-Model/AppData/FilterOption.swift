//
//  FilterOption.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/10.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

typealias FilterType = (fee:(from:Int, to:Int), sortType:SortType, lotType:ParkingLotType, inOutType:InOutDoorType, option:(cctv:Bool, iotSensor:Bool, mechanical:Bool, allDay:Bool, outsideFlag:InOutDoorType, bleGateFlag:Bool))

// FilterType 용
/*
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
*/
/*
enum FilterOperationType: Int {
    case none, public_area, private_area
    
    var param: String {
        switch self {
        case .none:
            return ""
        case .public_area:
            return ParkingLotType.public_lot.rawValue
        case .private_area:
            return ParkingLotType.private_lot.rawValue
        }
    }
}
*/
/*
enum FilterAreaType: Int {
    case none, indoor, outdoor
}
*/
class FilterOption: NSObject, NSCoding {
    var from:Int = 0
    var to:Int = 10000
    var sortType:SortType = .price
    var lotType:ParkingLotType = .none
    var inOutType:InOutDoorType = .none
    var isCCTV:Bool = false
    var isIotSensor:Bool = false
    var isNoMechanical:Bool = false
    var isAllDay:Bool = false
    var isOutsideFlag:InOutDoorType = .none
    var isBleGateFlag:Bool = false
    
    var filter:FilterType {
        get {
            return FilterType (fee:(from:from, to:to), sortType:sortType, lotType:lotType, inOutType:inOutType, option:(cctv:isCCTV, iotSensor:isIotSensor, mechanical:isNoMechanical, allDay:isAllDay,  outsideFlag:isOutsideFlag, bleGateFlag:isBleGateFlag))
        }
    }
    
    override init() {
    }

    required init(coder aDecoder: NSCoder) {
        from = aDecoder.decodeObject(forKey: "from") as? Int ?? 0
        to = aDecoder.decodeObject(forKey: "to") as? Int ?? 10000
        sortType = aDecoder.decodeObject(forKey: "sortType") as? SortType ?? .price
        lotType = aDecoder.decodeObject(forKey: "operationType") as? ParkingLotType ?? .none
        inOutType = aDecoder.decodeObject(forKey: "inOutType") as? InOutDoorType ?? .none
        isCCTV = aDecoder.decodeObject(forKey: "isCCTV") as? Bool ?? false
        isIotSensor = aDecoder.decodeObject(forKey: "isIotSensor") as? Bool ?? false
        isNoMechanical = aDecoder.decodeObject(forKey: "isNoMechanical") as? Bool ?? false
        isAllDay = aDecoder.decodeObject(forKey: "isAllDay") as? Bool ?? false
        isOutsideFlag = aDecoder.decodeObject(forKey: "isOutsideFlag") as? InOutDoorType ?? .none
        isBleGateFlag = aDecoder.decodeObject(forKey: "isBleGateFlag") as? Bool ?? false
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(from, forKey: "from")
        aCoder.encode(to, forKey: "to")
        aCoder.encode(sortType.rawValue, forKey: "sortType")
        aCoder.encode(lotType.rawValue, forKey: "operationType")
        aCoder.encode(inOutType.rawValue, forKey: "inOutType")
        aCoder.encode(isCCTV, forKey: "isCCTV")
        aCoder.encode(isIotSensor, forKey: "isIotSensor")
        aCoder.encode(isNoMechanical, forKey: "isNoMechanical")
        aCoder.encode(isAllDay, forKey: "isAllDay")
        aCoder.encode(isNoMechanical, forKey: "isOutsideFlag")
        aCoder.encode(isAllDay, forKey: "isBleGateFlag")
    }
}