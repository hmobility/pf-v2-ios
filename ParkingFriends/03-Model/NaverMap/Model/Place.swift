//
//  Place.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/06.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

class Place: BaseModelType {
    var name:String = ""
    var road_address:String = ""
    var jibun_address:String = ""
    var phone_number:String = ""
    var x:Double = 0
    var y:Double = 0
    var distance:Double = 0
    var sessionId:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        road_address <- map["road_address"]
        jibun_address <- map["jibun_address"]
        phone_number <- map["phone_number"]
        x <- map["x"]
        y <- map["y"]
        distance <- map["distance"]
        sessionId <- map["sessionId"]
    }
}
