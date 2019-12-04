//
//  Receipt.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

public class Receipt: BaseModelType {
    var imageUrl:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override public func mapping(map: Map) {
        imageUrl <- map["imageUrl"]
    }
}
