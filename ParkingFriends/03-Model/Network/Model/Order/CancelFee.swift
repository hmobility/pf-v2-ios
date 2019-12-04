//
//  CancelFee.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

class CancelFee: BaseModelType {
    var totalAmount:Int = 0
    var paymentAmount:Int = 0
    var usePoint:Int = 0
    var cancelFee:Int = 0
    var refundAmount:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        totalAmount <- map["totalAmount"]
        paymentAmount <- map["paymentAmount"]
        usePoint <- map["usePoint"]
        cancelFee <- map["cancelFee"]
        refundAmount <- map["refundAmount"]
    }
}

