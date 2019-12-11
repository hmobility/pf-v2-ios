//
//  DetailEvents.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

// 이벤트사항 상세 조회   /v1/events/{id}
class EventsContents: BaseModelType {
    var id:Int = 0
    var title:String = ""
    var content:String = ""
    var dateCreated:String = ""
    var elements:[NoticesElement] = [NoticesElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        content <- map["dateCreatcontented"]
        dateCreated <- map["dateCreated"]
        elements <- map["elements"]
    }
}

class EventsContentsElement: BaseModelType {
    var from:String = ""
    var to:String = ""
    var imageUrl:String = ""
    var thumbNailImageUrl:String = ""
    var expired:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        from <- map["from"]
        to <- map["to"]
        imageUrl <- map["imageUrl"]
        thumbNailImageUrl <- map["thumbNailImageUrl"]
        expired <- (map["expired"], BoolTransform())
    }
}
