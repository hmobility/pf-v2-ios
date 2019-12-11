//
//  Agreements.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Agreements: BaseModelType {
    var totalCount:Int = 0
    var elements:[AgreementElement] = [AgreementElement]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        totalCount <- map["totalCount"]
        elements <- map["elements"]
    }
}

class AgreementElement: BaseModelType {
    var id:Int = 0
    var type:AgreementType?
    var name:String = ""
    var descript:String = ""
    var url:String = ""
    var necessary:Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        type <- (map["type"], EnumTransform<AgreementType>())
        name <- map["name"]
        descript <- map["descript"]
        url <- map["url"]
        necessary <- (map["necessary"], BoolTransform())
    }
}
