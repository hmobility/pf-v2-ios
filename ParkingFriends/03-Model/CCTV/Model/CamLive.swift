//
//  CamLogin.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

class CamLive: BaseModelType {
    var resultCode:String = ""
    var resultMsg:String = ""
    var camId:String = ""
    var camName:String = ""
    var zeroConf:CameraType?
    var imageUri:String = ""
    var liveUri:String = ""
    var lowLiveUri:String = ""

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        resultCode <- map["resultCode"]
        resultMsg <- map["resultMsg"]
        camId <- map["camId"]
        
        camName <- map["camName"]
        zeroConf <- map["zeroConf"]
        imageUri <- map["imageUri"]
        liveUri <- map["liveUri"]
        lowLiveUri <- map["lowLiveUri"]
    }
}
