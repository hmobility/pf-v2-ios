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

class Otp: BaseModel {
    var otpId:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        otpId <- map["otpId"]
    }
}
