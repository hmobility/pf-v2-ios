//
//  Events.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Events: BaseModelType {
    var totalCount:Int = 0
    var elements:[NoticesElement] = [NoticesElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["NoticesElement"]
    }
}

class EventsElement: BaseModelType {
    var id:Int = 0
    var title:String = ""
    var dateCreated:String = ""
    var from:String = ""
    var to:String = ""
    var imageUrl:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        dateCreated <- map["dateCreated"]
        from <- map["from"]
        to <- map["to"]
        imageUrl <- map["imageUrl"]
    }
}

class EventsContent: BaseModelType {
    var id:Int = 0
    var title:String = ""
    var content:String = ""
    var dateCreated:String = ""
    var from:String = ""
    var to:String = ""
    var imageUrl:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        dateCreated <- map["dateCreated"]
        from <- map["from"]
        to <- map["to"]
        imageUrl <- map["imageUrl"]
    }
}
