//
//  OrderPreview.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class OrderPreview: BaseModelType {
    var totalAmount:Int = 0
    var parkingLotName:String = ""
    var parkingItemType:ProductType?
    var from:String = ""
    var to:String = ""
    var cars:[OrderPreviewCar] = []
    var point:Int = 0
    var creditCardId:Int = 0
    var coupons:[OrderPreviewCoupon] = []
    
    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        totalAmount <- map["totalAmount"]
        parkingLotName <- map["parkingLotName"]
        parkingItemType <- map["parkingItemType"]
        from <- map["from"]
        to <- map["to"]
        cars <- map["cars"]
        point <- map["point"]
        creditCardId <- map["creditCardId"]
        coupons <- map["OrderPreviewCoupon"]
    }
}

class OrderPreviewCar: BaseModelType {
    var id:Int = 0
    var name:String = ""
    var carNo:String = ""
    var defaultFlag:Bool = false

    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        carNo <- map["carNo"]
        defaultFlag <- (map["defaultFlag"], BoolTransform())
    }
}

class OrderPreviewCoupon: BaseModelType {
    var id:Int = 0
    var parkingItemName:String = ""
    var orderDate:String = ""
    var desc1:String = ""
    var desc2:String = ""
    var companyType:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        id <- map["id"]
        parkingItemName <- map["parkingItemName"]
        orderDate <- map["orderDate"]
        desc1 <- map["desc1"]
        desc2 <- map["desc2"]
        companyType <- map["companyType"]
    }
}
