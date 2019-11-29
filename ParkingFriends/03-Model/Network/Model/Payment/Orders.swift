//
//  OrderPreview.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

class Transaction: BaseModelType {
    var transactionId:String = ""

    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        transactionId <- map["transactionId"]
    }
}

class Orders: BaseModelType {
    var totalCount:Int = 0
    var elements:[OrdersElement] = [OrdersElement]()

    required init?(map: Map) {
        super.init(map: map)
    }
     
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class OrdersElement: BaseModelType {
    var id:Int = 0
    var status:String = ""
    var product:[Product] = [Product]()
    var parkinglot:[Parkinglot] = [Parkinglot]()
    var from:String = ""
    var to:String = ""
    var dateCreated:String = ""
    var dateCanceled:String = ""
    var paymentMethod:String = ""
    var totalAmount:Int = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
      
    override func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        product <- map["product"]
        parkinglot <- map["parkinglot"]
        from <- map["from"]
        to <- map["to"]
        dateCreated <- map["dateCreated"]
        dateCanceled <- map["dateCanceled"]
        paymentMethod <- map["paymentMethod"]
        totalAmount <- map["totalAmount"]
    }
}

class Product: BaseModelType {
    var id:Int = 0
    var status:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
    }
}

class Parkinglot: BaseModelType {
    var id:Int = 0
    var name:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
     }
       
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

