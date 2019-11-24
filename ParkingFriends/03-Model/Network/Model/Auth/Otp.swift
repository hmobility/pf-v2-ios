//
//  Otp.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/24.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

public class Otp: BaseModelType {
    var otpId:String = ""
    var memberExist:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        otpId <- map["otpId"]
        memberExist <- (map["memberExist"], BoolTransform())
    }
}
