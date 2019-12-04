//
//  Contents.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

 // 회원 포인트 조회 : /v1/members/point

class Point: BaseModelType {
    var point:Int = 0

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        point <- map["point"]
    }
}
