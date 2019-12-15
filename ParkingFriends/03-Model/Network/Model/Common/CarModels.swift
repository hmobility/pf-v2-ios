//
//  CarModels.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class CarModels: BaseModelType {
    var totalCount:Int = 0
    var elements:[CarModelElement] = [CarModelElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class CarModelElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var descript: String = ""
    var brand:CarBrandsElement?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        descript <- map["description"]
        brand <- map["brand"]
    }
}
