//
//  OverFee.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

class OverFee: BaseModelType {
    var amount:Int = 0
    var overMinutes:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        amount <- map["amount"]
        overMinutes <- map["overMinutes"]
    }
}


