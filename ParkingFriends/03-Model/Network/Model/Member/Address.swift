//
//  Address.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/02.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//
import Foundation
import Alamofire
import ObjectMapper


// 회원 주소 목록 조회: /v1/members/address

class Address: BaseModelType {
    var totalCount:Int = 0
    var elements:[AddressElement] = [AddressElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class AddressElement: BaseModelType {
    var id:Int = 0
    var customerId:String = ""
    var address:String = ""
    var detail:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var type:AddressType = .home
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        customerId <- map["customerId"]
        address <- map["address"]
        detail <- map["detail"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        type <- map["type"]
    }
}
