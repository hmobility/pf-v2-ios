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
    
    // 주차장 상세 조회
    static func parkinglots(id:Int, from:String, to:String , httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["from": from, "to":to]
        let url = build(host:host, endpoint:"/parkinglots/\(id)", params: query)
        return (httpMethod, url, auth, nil)
    }
    
    // 주차장 공유  - Multiparts(formadata)
    /*
    static func share(address:String, images:[Image], httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["from": from, "to":to]
        let url = build(host:host, endpoint:"/parkinglots/\(id)", params: query)
        return (httpMethod, url, auth, nil)
    }
     */
    
    // 즐겨찾기 조회
    static func favorites(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/parkinglots/favorites", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 즐겨찾기 등록
    static func favorites(parkinglotId:Int, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/parkinglots/favorites/\(parkinglotId)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 즐겨찾기 삭제
    static func delete_favorites(parkinglotId:Int, httpMethod:HttpMethod = .delete, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/parkinglots/favorites/\(parkinglotId)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주차장 반경 목록 조회
    static func delete_favorites(lat:String, lon:String, radius:String, start:String, end:String ,sort:SortType, productType:ProductType, monthlyFrom:String, monthlyCount:Int, filter:FilterType, httpMethod:HttpMethod = .delete, auth:APIAuthType = .OAuth2) -> RestURL  {
        let filter:Params = ["fee":["from":filter.fee.from, "to":filter.fee.to], "lotType":filter.lotType, "option":["cctv":filter.option.cctv, "iotSensor":filter.option.iotSensor, "mechanical":filter.option.mechanical, "allDayOperation":filter.option.allDayOperation]]
        
        let params:Params = ["lat": lat, "lon":lon, "radius":radius, "sort":sort.rawValue, "start":start , "end":end, "productType":productType.rawValue, "monthlyFrom":monthlyFrom, "monthlyCount":monthlyCount, "filter":filter]
        let url = build(host:host, endpoint:"/parkinglots/within", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 주차장 예약 가능 시간 조회
     static func available_times(id:Int, from:String, to:String , httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
         let query:Params = ["from": from, "to":to]
         let url = build(host:host, endpoint:"/parkinglots/\(id)/available-times", params: query)
         return (httpMethod, url, auth, nil)
     }
}
