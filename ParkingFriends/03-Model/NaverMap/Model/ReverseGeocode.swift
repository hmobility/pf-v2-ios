//
//  reverseGeocode.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/12.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

// Naver Map - Reverse Geocode

class ReverseGeocode: BaseModelType {
    var name:MapOrders = .none
    var code:Code?
    var region:Region?
    var land:Land?
    
    var shortAddress:String {
        get {
            return land?.name ?? ""
        }
    }

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        code <- map["code"]
        region <- map["region"]
        land <- map["land"]
    }
}

class Code: BaseModelType {
    var id:String = ""
    var type:String = ""
    var mappingId:String = ""

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        mappingId <- map["mappingId"]
    }
}

class Region: BaseModelType {
    var area0:Area?
    var area1:Area?
    var area2:Area?
    var area3:Area?
    var area4:Area?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        area0 <- map["area0"]
        area1 <- map["area1"]
        area2 <- map["area2"]
        area3 <- map["area3"]
        area4 <- map["area4"]
    }
}

class Area: BaseModelType {
    var name:String = ""
    var coords:String = ""
    var alias:String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        coords <- map["coords"]
        alias <- map["alias"]
    }
}

class Coords: BaseModelType {
    var name:String = ""
    var center:Center?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        center <- map["center"]
    }
}

class Center: BaseModelType {
    var crs:String = ""
    var x:String = ""
    var y:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        crs <- map["crs"]
        x <- map["x"]
        y <- map["y"]
    }
}

class Land: BaseModelType {
    var type:Int = 0
    var number1:Int = 0
    var number2:Int = 0
    var addition0:Addition?
    var addition1:Addition?
    var addition2:Addition?
    var addition3:Addition?
    var addition4:Addition?
    var name:String = ""
    var coords:Coords?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        type <- map["type"]
        number1 <- map["number1"]
        number2 <- map["number2"]
        addition0 <- map["addition0"]
        addition1 <- map["addition1"]
        addition2 <- map["addition2"]
        addition3 <- map["addition3"]
        addition4 <- map["addition4"]
        name <- map["name"]
        coords <- map["coords"]
    }
}

class Addition: BaseModelType {
    var type:String = ""
    var value:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        type <- map["type"]
        value <- map["value"]
    }
}
