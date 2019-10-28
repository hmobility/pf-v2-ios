//
//  Reviews.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Reviews: BaseModel {
    var totalCount:Int = 0
    var meanRating:Double = 0
    var elements:[ReviewsElement] = [ReviewsElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        meanRating <- map["meanRating"]
        elements <- map["ReviewsElement"]
    }
}

class ReviewsElement: BaseModel {
    var id:Int = 0
    var rating:Int = 0
    var review:String = ""
    var dateCreated:String = ""
    var nickname:String = ""
    var level:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        rating <- map["rating"]
        review <- map["review"]
        dateCreated <- map["dateCreated"]
        nickname <- map["nickname"]
        level <- map["level"]
    }
}

