//
//  Geocode.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

// Naver Map - Geocode

class Geocode: BaseModelType {
    var roadAddress:String = ""
    var jibunAddress:String = ""
    var englishAddress:String = ""
    var addressElements:[GeoAdddressElement] = []
    var x:Double = 0
    var y:Double = 0
    var distance:Double = 0
    
    required init?(map: Map) {
         super.init(map: map)
     }
     
     override func mapping(map: Map) {
        roadAddress <- map["roadAddress"]
        jibunAddress <- map["jibunAddress"]
        englishAddress <- map["englishAddress"]
        addressElements <- map["addressElements"]
        x <- map["x"]
        y <- map["y"]
        distance <- map["distance"]
     }
}

class GeoAdddressElement: BaseModelType {
    var types:[GeoAddressType] = []
    var longName:String = ""
    var shortName:String = ""
    var code:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        types <- map["types"]
        longName <- map["longName"]
        shortName <- map["shortName"]
        code <- map["code"]
    }
}
