//
//  MapResult.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/12.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

class MapResult: BaseModelType {
    var status:[String:Any] = [:]
    var data:[[String:Any]] = []
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        if let response = map.JSON["status"], response is String {
            status = ["status" : response]
        } else {
            status <- map["status"]
        }
        
        if map["results"].isKeyPresent {
            data <- map["results"]                  // Reverse Geocode
        }
        
        if map["addresses"].isKeyPresent {
            data <- map["addresses"]                // Geocode
        }
        
        if map["places"].isKeyPresent {
            data <- map["places"]                   // Place
        }
    }
}


