//
//  OrderParkinglotElement.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

public class OrderParkinglot: BaseModelType {
    var id:Int = 0
    var name:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}


