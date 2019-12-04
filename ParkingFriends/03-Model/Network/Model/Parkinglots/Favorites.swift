//
//  Favorites.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// 즐겨찾기 조회 :  /v1/parkinglots/favorites

class Favorites: BaseModelType {
    var totalCount:Int = 0
    var elements:[FavoriteElement] = [FavoriteElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class FavoriteElement: BaseModelType {
    var id:Int = 0
    var parkinglot:[FavoriteParkingElement] = [FavoriteParkingElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        parkinglot <- map["parkinglot"]
    }
}

class FavoriteParkingElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
