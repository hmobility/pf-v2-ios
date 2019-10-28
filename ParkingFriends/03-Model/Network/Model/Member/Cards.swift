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

class Cards: BaseModel {
    var totalCount:Int = 0
    var elements:[Card] = [Card]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class Card: BaseModel {
    var id:Int = 0
    var name:String = ""
    var defaultFlag:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        defaultFlag <- (map["defaultFlag"], BoolTransform())
    }
}
