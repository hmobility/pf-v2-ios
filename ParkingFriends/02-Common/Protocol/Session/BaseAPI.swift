//
//  baseAPI.swift
//  ParkingFriends
//
//  Created by mkjwa on 2019/10/15.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Foundation

typealias RestURL = (method:HttpMethod, url:URL, auth:APIAuthType, params:Params?)
typealias RequestURL = (url:URL, params:Params?)

enum APIAuthType {
    case OAuth2, serviceKey, none
}

protocol BaseAPI {
    
}

extension BaseAPI {
    static func build(host:HostType, endpoint:String, query:Params?) -> URL {
        var components = URLComponents()
        components.scheme = host.scheme
        components.host = host.domain
        components.path = host.rootPath + endpoint
        
        if host.port > 0 {
            components.port = host.port
        }

        if let params = query {
            components.queryItems = params.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }

        return components.url!
    }
}
