//
//  FAQs.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class FAQsContents: BaseModelType {
    var id:Int = 0
    var title:String = ""
    var content:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
    }
}
