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

class Members: BaseModel {
    var id:Int = 0
    var username:String = ""
    var email:String = ""
    var nickname:String = ""
    var point:Int = 0
    var car:[Car] = [Car]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        email <- map["email"]
        nickname <- map["nickname"]
        point <- map["point"]
        car <- map["car"]
    }
}

class Car: BaseModel {
    var trimId:Int = 0
    var colorId:Int = 0
    var number:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        trimId <- map["trimId"]
        colorId <- map["colorId"]
        number <- map["number"]
    }
}
