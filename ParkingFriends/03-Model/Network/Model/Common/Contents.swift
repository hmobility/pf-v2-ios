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

class Contents: BaseModelType {
    var totalCount:Int = 0
    var elements:[ContentsElement] = [ContentsElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["ContentsElement"]
    }
}

class ContentsElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var code:String = ""
    var descript:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        descript <- map["description"]
    }
}
