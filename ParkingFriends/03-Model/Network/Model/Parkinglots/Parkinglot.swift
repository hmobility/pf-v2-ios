//
//  Parkinglot.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// 주차장 목록 조회 :  /v1/parkinglots/{id}

class Parkinglot: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var lat:String = ""
    var lon:String = ""
    var address:String = ""
    var images:[Image] = [Image]()
    var roadViewId:String = ""
    var favoriteFlag:Bool = false
    var type:ParkingLotType?
    var flagElements:[FlagElement] = [FlagElement]()
    var products:[ProductElement] = [ProductElement]()
    var totalLotCount:Int = 0
    var availableLotCount:Int = 0
    var operationTimes:[ParkinglotOperationTime] = [ParkinglotOperationTime]()
    var notices:[String] = [String]()
    var review:[Review] = [Review]()
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
        lat <- map["lat"]
        lon <- map["lon"]
        address <- map["address"]
        images <- map["images"]
        roadViewId <- map["roadViewId"]
        favoriteFlag <- (map["favoriteFlag"], BoolTransform())
        type <- (map["ParkingLotType"], EnumTransform<ParkingLotType>())
        totalLotCount <- map["totalLotCount"]
        availableLotCount <- map["availableLotCount"]
        operationTimes <- map["operationTimes"]
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

class ParkinglotOperationTime: BaseModelType {
    var type:OperationTimeType?
    var operationFlag:Bool = false
    
    var from:String = ""
    var to:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        type <- (map["type"], EnumTransform<OperationTimeType>())
        operationFlag <- map["operationFlag"]
        from <- map["from"]
        to <- map["to"]
    }
}


class FlagElement: BaseModelType {
    var partnerFlag:Bool = false
    var cctvFlag:Bool = false
    var outsideFlag:Bool = false
    var iotSensorFlag:Bool = false
    var chargerFlag:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        partnerFlag <- (map["partnerFlag"], BoolTransform())
        cctvFlag <- (map["cctvFlag"], BoolTransform())
        outsideFlag <- (map["outsideFlag"], BoolTransform())
        iotSensorFlag <- (map["iotSensorFlag"], BoolTransform())
        chargerFlag <- (map["chargerFlag"], BoolTransform())
    }
}

class ProductElement: BaseModelType {
    var id:Int = 0
    var type:ProductType?
    var name:String = ""
    var descript:String = ""
    var price:Int = 0
    var available:Bool = false
    var availableTimes:[OperationTime] = [OperationTime]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        descript <- map["description"]
        price <- map["price"]
        available <- (map["available"], BoolTransform())
        availableTimes <- map["availableTimes"]
    }
}

class Review: BaseModelType {
    var pointRate:Double = 0
    var totalCount:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        pointRate <- map["pointRate"]
        totalCount <- map["totalCount"]
    }
}
