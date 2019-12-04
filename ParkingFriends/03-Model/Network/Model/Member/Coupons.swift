//
//  Contents.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

// 회원 쿠폰 목록 조회 : /v1/members/coupons

class Coupons: BaseModelType {
    var totalCount:Int = 0
    var elements:[Coupon] = [Coupon]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class Coupon: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var descript:String = ""
    var discountType:String = ""
    var discountValue:Int = 0
    var from:String = ""
    var to:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        descript <- map["description"]
        discountType <- map["discountType"]
        discountValue <- map["discountValue"]
        from <- map["from"]
        to <- map["to"]
    }
}
