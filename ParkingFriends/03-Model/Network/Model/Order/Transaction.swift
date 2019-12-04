//
//  Transaction.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

class Transaction: BaseModelType {
    var transactionId:String = ""

    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        transactionId <- map["transactionId"]
    }
}
