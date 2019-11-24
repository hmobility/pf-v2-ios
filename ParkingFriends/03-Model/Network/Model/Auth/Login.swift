//
//  Auth.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

public class Login: BaseModelType, NSCoding {
    var tokenType:String = ""
    var accessToken:String = ""
    var refreshToken:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        tokenType <- map["tokenType"]
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init()
        
        tokenType = (aDecoder.decodeObject(forKey: "tokenType") as? String)!
        accessToken = (aDecoder.decodeObject(forKey: "accessToken") as? String)!
        refreshToken = (aDecoder.decodeObject(forKey: "refreshToken") as? String)!
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(tokenType, forKey: "tokenType")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(refreshToken, forKey: "refreshToken")
    }
}
