//
//  PointsAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire

class PointsAPI: BaseAPI {
    // 포인트 상품 조회
    static func item(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/items/point", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 포인트 상품 조회
    static func points(id:Int, paymentMethod:PaymentType, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["id": id, "paymentMethod": paymentMethod.rawValue]
        let url = build(host:host, endpoint:"/points", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 포인트 충전 내역
    static func points(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/points", params: nil)
        return (httpMethod, url, auth, nil)
    }
}
