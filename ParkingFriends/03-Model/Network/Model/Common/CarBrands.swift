//
//  CarsBrands.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class CarBrands: BaseModelType {
    var totalCount:Int = 0
    var elements:[CarBrandsElement] = [CarBrandsElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["CarBrandsElement"]
    }
}

class CarBrandsElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var descript: String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        descript <- map["description"]
    }
}
