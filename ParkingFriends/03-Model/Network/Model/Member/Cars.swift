//
//  Cars.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/02.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//
import Foundation
import Alamofire
import ObjectMapper

// 회원 차량 목록 조회 : /v1/members/cars

class Cars: BaseModelType {
    var totalCount:Int = 0
    var elements:[CarsElement] = [CarsElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class CarsElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var carNo:String = ""
    var defaultFlag:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        carNo <- map["carNo"]
        defaultFlag <- (map["defaultFlag"], BoolTransform())
    }
}
