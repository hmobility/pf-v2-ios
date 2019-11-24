//
//  BaseModelType.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/17.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

public class BaseModelType: NSObject, Mappable {
    
   // static let httpSession:HttpSession = HttpSession.shared
    
    override init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {}
}
