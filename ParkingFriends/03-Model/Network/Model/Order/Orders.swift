//
//  OrderPreview.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

class Orders: BaseModelType {
    var totalCount:Int = 0
    var elements:[OrderElement] = [OrderElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class OrderElement: BaseModelType {
    var id:Int = 0
    var status:OrderStatusType?
    var type:ProductType?
    var product:OrderProduct?
    var parkingLot:OrderParkinglot?
    var from:String = ""
    var to:String = ""
    var dateCreated:String = ""
    var dateCanceled:String = ""
    var paymentMethod:String = ""
    var totalAmount:Int = 0
    var couponId:Int = 0
    var usePoint:Int = 0
    var refundAmount:Int = 0
    var refundPoint:Int = 0
    var car:OrderCarElement?
    var receiptUrl:String = ""
    var cctvFlag:Bool = false
    var gift:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
   
    override func mapping(map: Map) {
        id <- map["id"]
        status <- (map["status"], EnumTransform<OrderStatusType>())
        type <- (map["type"], EnumTransform<ProductType>())
        product <- map["product"]
        parkingLot <- map["parkingLot"]
        from <- map["from"]
        to <- map["to"]
        dateCreated <- map["dateCreated"]
        dateCanceled <- map["dateCanceled"]
        paymentMethod <- map["paymentMethod"]
        totalAmount <- map["totalAmount"]
        couponId <- map["couponId"]
        usePoint <- map["usePoint"]
        refundAmount <- map["refundAmount"]
        refundPoint <- map["refundPoint"]
        car <- map["car"]
        receiptUrl <- map["receiptUrl"]
        cctvFlag <- (map["cctvFlag"], BoolTransform())
        gift <- (map["gift"], BoolTransform())
    }
}

public class OrderProduct: BaseModelType {
    var id:Int = 0
    var name:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

public class OrderParkinglot: BaseModelType {
    var id:Int = 0
    var name:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

class OrderCarElement: BaseModelType {
    var number:String = ""
    var phoneNumber:String = ""

    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        number <- map["number"]
        phoneNumber <- map["phoneNumber"]
    }
}
