//
//  ParkinglotsAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire

class ParkingLotAPI: BaseAPI {
    // 주차장 목록 조회
    static func parkinglots(lat:String, long:String, radius:String, sort:SortType, start:String, end:String, productType:ProductType, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["lat": lat, "long":long, "radius": radius, "sort":sort.rawValue, "start":start, "end":end, "productType":productType.rawValue]
        let url = build(host:host, endpoint:"/parkinglots", params: query)
        return (httpMethod, url, auth, nil)
    }
}
