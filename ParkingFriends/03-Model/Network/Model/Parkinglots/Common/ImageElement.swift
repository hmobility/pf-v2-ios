//
//  Image.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

public class ImageElement: BaseModelType {
    var url:String = ""
    var name:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        url <- map["url"]
        name <- map["name"]
    }
}
