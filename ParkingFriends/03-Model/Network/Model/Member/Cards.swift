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

    // 회원 신용카드 목록 조회 : /v1/memberscards

class Cards: BaseModelType {
    var totalCount:Int = 0
    var elements:[CardElement] = [CardElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

public class CardElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var defaultFlag:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        defaultFlag <- (map["defaultFlag"], BoolTransform())
    }
}
