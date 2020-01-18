//
//  Parkinglots.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// 주차장 목록 조회 : /v1/parkinglots

class Parkinglots: BaseModelType {
    var totalCount:Int = 0
    var elements:[ParkinglotElement] = [ParkinglotElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class ParkinglotElement: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var distance:Int = 0
    var lat:String = ""
    var lon:String = ""
    var totalLotCount:Int = 0
    var availableLotCount:Int = 0
    var type:ParkingLotType?
    var partnerFlag:Bool = false
    var address:String = ""
    var images:[ImageElement] = [ImageElement]()
    var thumbnail:String = ""
    var cctvCount:Int = 0
    var baseOperationTime:OperationTime?
    var holidayOperationTime:OperationTime?
    var saturdayOperationTime:OperationTime?
    var sundayOperationTime:OperationTime?
    var roadViewId:String = ""
    var parkingAvailable:Bool = false
    var basementFlag:Bool = false
    var selfParking:Bool = false
    var lprFlag:Bool = false
    var kioskFlag:Bool = false
    var cashierFlag:Bool = false
    var helperFlag:Bool = false
    var extraLotFlag:Bool = false
    var speedBump:Bool = false
    var autoIssuingFlag:Bool = false
    var lineMarkingFlag:Bool = false
    var sensorFlag:Bool = false
    var guideBoardFlag:Bool = false
    var speakerFlag:Bool = false
    var parkingBreakerFlag:Bool = false
    var supportItems:[ParkingLotType] = [ParkingLotType]()
    var baseFee:[Fee] = [Fee]()
    var dayFee:[Fee] = [Fee]()
    var satFee:[Fee] = [Fee]()
    var sunFee:[Fee] = [Fee]()
    var holidayFee:[Fee] = [Fee]()
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        distance <- map["distance"]
        lat <- map["lat"]
        lon <- map["lon"]
        totalLotCount <- map["totalLotCount"]
        availableLotCount <- map["availableLotCount"]
        type <- (map["ParkingLotType"], EnumTransform<ParkingLotType>())
        partnerFlag <- (map["partnerFlag"], BoolTransform())
        address <- map["address"]
        images <- map["images"]
        thumbnail <- map["thumbnail"]
        cctvCount <- map["cctvCount"]
        baseOperationTime <- map["baseOperationTime"]
        holidayOperationTime <- map["holidayOperationTime"]
        saturdayOperationTime <- map["saturdayOperationTime"]
        sundayOperationTime <- map["sundayOperationTime"]
        roadViewId <- map["roadViewId"]
        parkingAvailable <- (map["parkingAvailable"], BoolTransform())
        basementFlag <- (map["basementFlag"], BoolTransform())
        selfParking <- (map["selfParking"], BoolTransform())
        lprFlag <- (map["lprFlag"], BoolTransform())
        kioskFlag <- (map["kioskFlag"], BoolTransform())
        cashierFlag <- (map["cashierFlag"], BoolTransform())
        helperFlag <- (map["helperFlag"], BoolTransform())
        extraLotFlag <- (map["extraLotFlag"], BoolTransform())
        speedBump <- (map["speedBump"], BoolTransform())
        autoIssuingFlag <- (map["autoIssuingFlag"], BoolTransform())
        lineMarkingFlag <- (map["lineMarkingFlag"], BoolTransform())
        sensorFlag <- (map["sensorFlag"], BoolTransform())
        guideBoardFlag <- (map["guideBoardFlag"], BoolTransform())
        speakerFlag <- (map["speakerFlag"], BoolTransform())
        supportItems <- (map["supportItems"], EnumTransform<ParkingLotType>())
        baseFee <- map["baseFee"]
        dayFee <- map["dayFee"]
        satFee <- map["satFee"]
        sunFee <- map["sunFee"]
        holidayFee <- map["holidayFee"]
    }
}
