//
//  Usage.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/20.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper

class Usages: BaseModelType {
    var orderInfo:UsageOrderInfo?
    var payDay:String = ""
    var resFrom:String = ""
    var resTo:String = ""
    var desc1:String = ""
    var desc2:String = ""
    var elapsedMinutes:Int = 0
    var cctv:String = ""
    var camIds:[String] = []
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        orderInfo <- map["orderInfo"]
        payDay <- map["payDay"]
        resFrom <- map["resFrom"]
        resTo <- map["resTo"]
        desc1 <- map["desc1"]
        desc2 <- map["desc2"]
        elapsedMinutes <- map["elapsedMinutes"]
        cctv <- map["cctv"]
        camIds <- map["camIds"]
    }
}

class UsageOrderInfo: BaseModelType {
    var id:Int = 0
    var status:OrderStatusType?
    var type:ProductType?
    var dateCanceled:String = ""
    var quantity:Int = 0
    var paymentMethod:PaymentMethodType?
    var totalAmount:Int = 0
    var paymentAmount:Int = 0
    var couponId:Int = 0
    var usePoint:Int = 0
    var refundAmount:Int = 0
    var refundPoint:Int = 0
    var productName:String = ""
    var parkingLot:UsageParkingLot?
    var car:UsageCar?
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        type <- map["type"]
        dateCanceled <- map["dateCanceled"]
        quantity <- map["quantity"]
        paymentMethod <- map["paymentMethod"]
        totalAmount <- map["totalAmount"]
        paymentAmount <- map["paymentAmount"]
        couponId <- map["couponId"]
        usePoint <- map["usePoint"]
        refundAmount <- map["refundAmount"]
        refundPoint <- map["refundPoint"]
        productName <- map["product"]
        parkingLot <- map["parkingLot"]
        car <- map["car"]
    }
}

public class UsageParkingLot: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var lat:String = ""
    var lon:String = ""
    var bleGateFlag:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        lat <- map["lat"]
        lon <- map["lon"]
        bleGateFlag <- (map["bleGateFlag"], BoolTransform())
    }
}

public class UsageCar: BaseModelType {
    var number:String = ""
    var phoneNumber:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override public func mapping(map: Map) {
        number <- map["number"]
        phoneNumber <- map["phoneNumber"]
    }
}

