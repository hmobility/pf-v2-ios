//
//  Address.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

// 주소 조회  /v1/address

class SearchAddress: BaseModelType {
    var totalCount:Int = 0
    var elements:[SearchAddressElement] = [SearchAddressElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class SearchAddressElement: BaseModelType {
    var postalCode:String = ""
    var lat:String = ""
    var lon:String = ""
    var fullAddress:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        postalCode <- map["postalCode"]
        lat <- map["lat"]
        lon <- map["lon"]
        fullAddress <- map["fullAddress"]
    }
}

