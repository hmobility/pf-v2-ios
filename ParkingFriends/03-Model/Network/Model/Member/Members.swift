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

// 회원 상세 조회 : /v1/members

class Members: BaseModelType {
    var id:Int = 0
    var username:String = ""
    var email:String = ""
    var nickname:String = ""
    var point:Int = 0
    var car:MemberCar?

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

class MemberCar: BaseModelType {
    var totalCount:Int = 0
    var elements:[MemberCarElement] = [MemberCarElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class MemberCarElement: BaseModelType {
    var modelId:Int = 0
    var number:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        modelId <- map["modelId"]
        number <- map["number"]
    }
}
