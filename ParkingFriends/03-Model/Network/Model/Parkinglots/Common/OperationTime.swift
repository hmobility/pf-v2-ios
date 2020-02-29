//
//  OperationTime.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class OperationTime: BaseModelType {
    var from:String = ""
    var to:String = ""
    
    var fromDate:Date? {
        get {
            return from.toDate
        }
    }
    
    var toDate:Date? {
        get {
            return to.toDate
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        from <- map["from"]
        to <- map["to"]
    }
}
