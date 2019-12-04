//
//  Product.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

public class OrderProduct: BaseModelType {
    var id:Int = 0
    var status:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override public func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
    }
}
