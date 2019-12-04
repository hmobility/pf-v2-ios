//
//  AvailableTimes.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// 주차장 예약 가능 시간 조회:  /v1/parkinglots/{id}/available-times

class AvailableTimes: BaseModelType {
    var totalCount:Int = 0
    var available:Bool = false
    var elements:[OperationTime] = [OperationTime]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        available <- (map["available"], BoolTransform())
        elements <- map["elements"]
    }
}
