//
//  OrderDetail.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

class OrdersDetail: BaseModelType {
    var id:Int = 0
    var status:OrderStatusType?
    var product:OrderProduct?
    var parkinglot:OrderParkinglot?
    var from:String = ""
    var to:String = ""
    var dateCreated:String = ""
    var dateCanceled:String = ""
    var quantity:Int = 0
    var paymentMethod:PaymentType?
    var totalAmount:Int = 0
    var paymentAmount:Int = 0
    var couponId:Int = 0
    var usePoint:Int = 0
    var cancelFee:Int = 0
    var refundAmount:Int = 0
    var car:OrdersCarElement?
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        status <- (map["status"], EnumTransform<OrderStatusType>())
        product <- map["product"]
        parkinglot <- map["parkinglot"]
        from <- map["from"]
        to <- map["to"]
        dateCreated <- map["dateCreated"]
        dateCanceled <- map["dateCanceled"]
        quantity <- map["quantity"]
        paymentMethod <- (map["paymentMethod"], EnumTransform<PaymentType>())
        totalAmount <- map["totalAmount"]
        paymentAmount <- map["paymentAmount"]
        couponId <- map["couponId"]
        usePoint <- map["usePoint"]
        cancelFee <- map["cancelFee"]
        refundAmount <- map["refundAmount"]
        car <- map["car"]
    }
}

class OrdersCarElement: BaseModelType {
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