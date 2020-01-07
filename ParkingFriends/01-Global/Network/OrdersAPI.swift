//
//  PaymentAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire

class OrdersAPI: BaseAPI {
    // 주문요약
    static func preview(productId:String, from:String, to:String, quantity:Int, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["productId": productId, "from": from, "to":to, "quantity":quantity]
        let url = build(host:host, endpoint:"/orders/preview", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 주문(트랜잭션) 생성
    static func orders(productId:String, from:String, to:String, quantity:Int, paymentMethod:String, usePoint:Int, totalAmount:Int, paymentAmount:Int, couponId:Int, car:(number:String, phoneNumber:String), httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["productId": productId, "from": from, "to":to, "quantity":quantity, "paymentMethod":paymentMethod, "usePoint":usePoint, "totalAmount":totalAmount, "paymentAmount":paymentAmount, "couponId":couponId, "car":["number":car.number, "phoneNumber":car.phoneNumber]]
        let url = build(host:host, endpoint:"/orders/preview", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 결제
    static func payments(transactionId:String, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(transactionId)/payments", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 목록
    static func orders(page:Int, size:Int, from:String, to:String, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["page": page, "size":size, "from": from, "to":to]
        let url = build(host:host, endpoint:"/orders/preview", params: query)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 상세(단일) 조회
    static func orders(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 취소 수수료 조회
    static func cancel_fee(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)/cancel-fee", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 취소
    static func delete_orders(id:Int, httpMethod:HttpMethod = .delete, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 변경(주차장 변경)
    static func change_orders(id:Int, parkinglotId:Int, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["parkinglotId": parkinglotId]
        let url = build(host:host, endpoint:"/orders/\(id)", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 주문 변경(주차장 변경)
    static func accuse(id:Int, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)/accuse", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 초과요금 조회
    static func over_fee(id:Int, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)/over-fee", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 변경(주차장 변경)
    static func expend(id:Int, minutes:Int, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["minutes": minutes]
        let url = build(host:host, endpoint:"/orders/\(id)/expend", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 대체 주차장 조회
    static func recommend(id:Int, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)/recommend", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 선물하기
    static func gift(id:Int, phoneNumber:String, carNumber:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["phoneNumber": phoneNumber, "carNumber": carNumber]
        let url = build(host:host, endpoint:"/orders/\(id)/gift", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 영수증 조회
    static func receipt(id:Int, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)/receipt", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 영수증 조회
    static func receipt_send(id:Int, sendType:ReceiptSendType, phoneNumber:String, email:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["sendType": sendType.rawValue, "phoneNumber": phoneNumber, email: email]
        let url = build(host:host, endpoint:"/orders/\(id)/receipt/send", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // ARS 결제
    static func ars(carNo:String, productId:Int, from:String, to:String, card:CardInfoType, httpMethod:HttpMethod = .put, auth:APIAuthType = .serviceKey) -> RestURL  {
        let params:Params = ["carNo": carNo, "productId": productId, "from": from, "to":to, "card":["cardNo":card.cardNo, "yearExpired":card.yearExpired, "monthExpired":card.monthExpired, "password":card.password, "birthDate":card.birthDate]]
        let url = build(host:host, endpoint:"/orders/ars", params: nil)
        return (httpMethod, url, auth, params)
    }
}