//
//  PaymentAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire

class PaymentAPI: BaseAPI {
    // 주문요약
    static func orders_preview(productId:String, from:String, to:String, quantity:Int, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
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
    static func orders_payments(transactionId:String, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(transactionId)/payments", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 목록 조회
    static func orders(page:Int, size:Int, from:String, to:String, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let query:Params = ["page": page, "size":size, "from": from, "to":to]
        let url = build(host:host, endpoint:"/orders/preview", params: query)
        return (httpMethod, url, auth, nil)
    }
    
    // 주문 단일 조회
    static func orders(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/orders/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
}
