//
//  CamLogin.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

class CamLogin: BaseModelType {
    var resultCode:String = ""
    var projectAuth:String = ""
    var duration:Int = 0
    var key:String = ""
    var projectId:String = ""
    var resultMsg:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        resultCode <- map["resultCode"]
        projectAuth <- map["projectAuth"]
        duration <- map["duration"]
        key <- map["key"]
        projectId <- map["projectId"]
        resultMsg <- map["resultMsg"]
    }
}
