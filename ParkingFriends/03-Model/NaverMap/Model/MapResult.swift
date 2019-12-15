//
//  MapResult.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/12.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

class MapResult: BaseModelType {
    var status:Status = Status()
    var data:[[String:Any]] = []
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        status <- map["status"]
        data <- map["results"]
    }
}

class Status: BaseModelType {
    var code:Int = 0
    var name:String = ""
    var message:String = ""
    
    override init() {
        super.init()
    }

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
        message <- map["message"]
    }
}

class MapError: BaseModelType {
    var errorCode:Int = 0
    var message:String = ""

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        errorCode <- map["code"]
        message <- map["message"]
    }
}


