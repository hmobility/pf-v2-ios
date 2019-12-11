//
//  CommonAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/24.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

struct CommonAPI:BaseAPI {
    // 차량 브랜드 조회
    static func cars_brands(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/cars/brands", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 차량 모델 조회
    static func cars_brands_models(brandId:String, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/cars/brands/\(brandId)/models", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 차량 상세 모델 조회
    static func cars_brands_models_trims(brandId:String, modelId:String, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/cars/brands/\(brandId)/models/\(modelId)/trims", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 약관 목록 조회
    static func agreements(httpMethod:HttpMethod = .get, auth:APIAuthType = .serviceKey) -> RestURL  {
        let url = build(host:host, endpoint:"/agreements", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주소 조회 , Deprecated
    static func address(keyword:String, httpMethod:HttpMethod = .get, auth:APIAuthType = .serviceKey) -> RestURL  {
        let params:Params = ["keyword": keyword]
        let url = build(host:host, endpoint:"/address", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 주차장 공유 문의 // Form Data
    static func parkinglots_inquiry(postalCode:String, address:String, phoneNumber:String, comment:String, images:[UIImage], httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["postalCode": postalCode, "address": address, "phoneNumber":phoneNumber, "comment":comment, "images":images]
        let url = build(host:host, endpoint:"/parkinglots/inquiry", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 신규 주차장 문의(제보) // Form Data
    static func parkinglots_suggest(postalCode:String, address:String, phoneNumber:String, comment:String, images:[UIImage], httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["postalCode": postalCode, "address": address, "phoneNumber":phoneNumber, "comment":comment, "images":images]
        let url = build(host:host, endpoint:"/parkinglots/suggest", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 주차장 최신정보 제보
    static func parkinglots_suggest(id:Int, type:String, comment:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["type":type, "comment":comment]
        let url = build(host:host, endpoint:"/parkinglots/\(id)/suggest", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 주차장 발굴 요청
    static func parkinglots_suggest_location(postalCode:String, address:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["postalCode":postalCode, "address":address]
        let url = build(host:host, endpoint:"/parkinglots/suggest-location", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 분류 목록 조회 (각종 유형 정보 조회)
    static func contents(type:ContentType, httpMethod:HttpMethod = .get, auth:APIAuthType = .serviceKey) -> RestURL  {
        let url = build(host:host, endpoint:"/contents/\(type.rawValue)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 이용후기 등록
    static func parkinglots_reviews(id:Int, rating:Int, review:String, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["rating":rating, "review":review]
        let url = build(host:host, endpoint:"/parkinglots/\(id)/reviews", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 이용후기 목록 조회
    static func parkinglots_reviews(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/parkinglots/\(id)/reviews", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 공지사항 목록 조회
    static func notices(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/notices", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 공지사항 상세 조회
    static func notices(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/notices/\(id)", params: nil)
         return (httpMethod, url, auth, nil)
    }
    
    // 이벤트 목록 조회
    static func events(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/events", params: nil)
         return (httpMethod, url, auth, nil)
    }
    
    // 이벤트사항 상세 조회
    static func events(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/events/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // FAQ 목록 조회
    static func faqs(type:String, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["type":type]
        let url = build(host:host, endpoint:"/faqs", params: query)
        return (httpMethod, url, auth, nil)
    }
    
    // FAQ 상세 조회
    static func faqs(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/faqs/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
}
