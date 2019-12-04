//
//  Within.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// 주차장 반경 목록 조회:  /v1/parkinglots/within

class Within: BaseModelType {
    var totalCount:Int = 0
    var elements:[WithinParkinglotElement] = [WithinParkinglotElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class WithinParkinglotElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var address:String = ""
    var distance:Int = 0
    var lat:String = ""
    var lon:String = ""
    var available:Bool = false
    var type:ParkingLotType?
    var partnerFlag:Bool = false
    var cctvFlag:Bool = false
    var outsideFlag:Bool = false
    var iotSensorFlag:Bool = false
    var chargerFlag:Bool = false
    var price:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        address <- map["address"]
        distance <- map["distance"]
        lat <- map["lat"]
        lon <- map["lon"]
        available <- (map["available"], BoolTransform())
        type <- (map["type"], EnumTransform<ParkingLotType>())
        partnerFlag <- (map["partnerFlag"], BoolTransform())
        cctvFlag <- (map["cctvFlag"], BoolTransform())
        outsideFlag <- (map["outsideFlag"], BoolTransform())
        iotSensorFlag <- (map["iotSensorFlag"], BoolTransform())
        chargerFlag <- (map["chargerFlag"], BoolTransform())
        price <- map["price"]
    }
}
