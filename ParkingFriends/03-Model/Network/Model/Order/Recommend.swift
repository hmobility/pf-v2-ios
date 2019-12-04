//
//  Recommend.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

// 대체 주차장 조회  /v1/orders/{id}/recommend
class Recommend: BaseModelType {
    var totalCount:Int = 0
    var elements:[RecommendElement] = [RecommendElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class RecommendElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var distance:Int = 0
    var lat:String = ""
    var lon:String = ""
    var type:ProductType?
    var partnerType:PartnerType?
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        distance <- map["distance"]
        lat <- map["lat"]
        lon <- map["lon"]
        type <- (map["type"], EnumTransform<ProductType>())
        partnerType <- (map["type"], EnumTransform<PartnerType>())
    }
}
