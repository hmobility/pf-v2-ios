//
//  WithinDistrict.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/23.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// 구별 주차장 건수 조회:  /v1/parkinglots/within-district

class WithinDistrict: BaseModelType {
    var totalCount:Int = 0
    var elements:[WithinDistrictElement] = [WithinDistrictElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class WithinDistrictElement: BaseModelType {
    var name:String = ""
    var count:Int = 0
    var lat:String = ""
    var lon:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        count <- map["count"]
        lat <- map["lat"]
        lon <- map["lon"]
    }
}
