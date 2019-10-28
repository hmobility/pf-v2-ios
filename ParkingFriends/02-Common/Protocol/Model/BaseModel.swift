//
//  BaseModel.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/17.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper


class BaseModel: NSObject, Mappable {
    
   // static let httpSession:HttpSession = HttpSession.shared
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {}
}
