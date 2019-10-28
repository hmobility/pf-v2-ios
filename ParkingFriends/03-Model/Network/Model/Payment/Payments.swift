//
//  OrderPreview.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Order: BaseModel {
    var orderId:Int = 0

    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        orderId <- map["orderId"]
    }
}

