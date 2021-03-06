//
//  ParkinglotsAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire

class ParkinglotAPI: BaseAPI {
    // 주차장 목록 조회
    static func parkinglots(lat:String, long:String, radius:String, sort:SortType, start:String, end:String, productType:ProductType, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["lat": lat, "long":long, "radius": radius, "sort":sort.rawValue, "start":start, "end":end, "productType":productType.rawValue]
        let url = build(host:host, endpoint:"/parkinglots", query: query)
        return (httpMethod, url, auth, nil)
    }
    
    // 주차장 상세 조회
    static func parkinglots(id:Int, from:String, to:String, type:ProductType, monthlyFrom:String, monthlyCount:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["from": from, "to":to, "type":type.rawValue, "monthlyFrom":monthlyFrom, "monthlyCount":monthlyCount]
        let url = build(host:host, endpoint:"/parkinglots/\(id)", query: query)
        return (httpMethod, url, auth, nil)
    }
    
    // 주차장 공유  - Multiparts(formadata)
    static func share(address:String, images:[ImageElement], httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["address": address, "images":images]
        let url = build(host:host, endpoint:"/parkinglots/share", query: query)
        return (httpMethod, url, auth, nil)
    }
    
    // 즐겨찾기 조회
    static func favorites(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/parkinglots/favorites", query: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 즐겨찾기 등록
    static func favorites(parkinglotId:Int, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/parkinglots/favorites/\(parkinglotId)", query: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 즐겨찾기 삭제
    static func delete_favorites(parkinglotId:Int, httpMethod:HttpMethod = .delete, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/parkinglots/favorites/\(parkinglotId)", query: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주차장 반경 목록 조회
    static func within(lat:String, lon:String, radius:String, start:String, end:String, productType:ProductType, monthlyFrom:String, monthlyCount:Int, filter:FilterType, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let filterParams:Params = ["fee":["from": filter.fee.from, "to": filter.fee.to], "lotType": filter.lotType.rawValue, "sort":  filter.sortType.rawValue, "option":["cctv": filter.option.cctv, "iotSensor": filter.option.iotSensor, "mechanical": filter.option.mechanical, "allDayOperation": filter.option.allDay, "outsideFlag": filter.option.outsideFlag.rawValue, "bleGateFlag": filter.option.bleGateFlag]]
        
        let params:Params = ["lat": lat, "lon":lon, "radius":radius, "start":start , "end":end, "productType":productType.rawValue, "monthlyFrom":monthlyFrom, "monthlyCount":monthlyCount, "filter":filterParams]
        
        debugPrint("[PARAMS] : ", params)
        let url = build(host:host, endpoint:"/parkinglots/within", query: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 주차장 예약 가능 시간 조회
    static func available_times(id:Int, from:String, to:String, type:ProductType, monthlyFrom:String, monthlyCount:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["from": from, "to":to, "type":type.rawValue, "monthlyFrom":monthlyFrom, "monthlyCount":monthlyCount]
        let url = build(host:host, endpoint:"/parkinglots/\(id)/available-times", query: query)
        return (httpMethod, url, auth, nil)
     }
    
    // 구별 주차장 건수 조회
    static func within_district(lat:String, lon:String, radius:String, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["lat": lat, "lon":lon, "radius":radius]
        
        let url = build(host:host, endpoint:"/parkinglots/within-district", query: nil)
        return (httpMethod, url, auth, params)
     }
}
