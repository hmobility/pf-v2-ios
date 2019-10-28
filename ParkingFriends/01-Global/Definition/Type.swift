//
//  Type.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

enum HttpMethod:String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ContentType:String {
    case withdraw = "WITHDRAW"
    case suggest_type = "SUGGEST_TYPE"
    case faq = "FAQ"
    case product_type = "PRODUCT_TYPE"
}

typealias Params = [String : Any]
