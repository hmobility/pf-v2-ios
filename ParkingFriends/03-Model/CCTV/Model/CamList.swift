//
//  CamLogin.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

class CamList: BaseModelType {
    var resultCode:String = ""
    var resultMsg:String = ""
    var cameraList:[CamElement] = []

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        resultCode <- map["resultCode"]
        resultMsg <- map["resultMsg"]
        cameraList <- map["cameraList"]
    }
}

class CamElement: BaseModelType {
    var camId:Int?
    var camName:String = ""
    var zeroConf:CameraType?
    var imageUri:String = ""
    var liveUri:String = ""
    var lowLiveUri:String = ""
    var camStatus:CamStatus?
    var cancelKeepPeriod:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        camId <- map["camId"]
        camName <- map["camName"]
        zeroConf <- map["zeroConf"]
        imageUri <- map["imageUri"]
        liveUri <- map["liveUri"]
        lowLiveUri <- map["lowLiveUri"]
        camStatus <- map["camStatus"]
        cancelKeepPeriod <- map["cancelKeepPeriod"]
    }
}
