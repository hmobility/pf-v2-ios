//
//  Fee.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

public class Fee: BaseModelType {
    var minute:Int = 0
    var fee:Int = 0
    var addMinute:Int = 0
    var addFee:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        minute <- map["minute"]
        fee <- map["fee"]
        addMinute <- map["addMinute"]
        addFee <- map["addFee"]
    }
}

