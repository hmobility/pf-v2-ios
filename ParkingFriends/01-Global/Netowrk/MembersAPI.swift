//
//  MembersAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/23.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire

struct MembersAPI:BaseAPI {
    // 회원 가입
    static func members(username:String, password:String, email:String, nickname:String, oldMemberId:Int, agreeMarketing:Bool, httpMethod:HttpMethod = .post, auth:APIAuthType = .serviceKey) -> RestURL  {
        let params:Params = ["username": username, "password": password, "email":email, "nickname":nickname, "oldMemberId":oldMemberId, "agreeMarketing":agreeMarketing]
        let url = build(host:host, endpoint:"/members", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원 상세 조회
    static func members(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 비밀번호 변경
    static func password(password:String, newPassword:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["password": password, "newPassword": newPassword]
        let url = build(host:host, endpoint:"/members/password", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 휴대폰 번호 변경
    static func phone_number(otp:String, otpId:String, phoneNumber:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["otp": otp, "otpId": otpId, "phoneNumber": phoneNumber]
        let url = build(host:host, endpoint:"/members/phone-number", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원정보 수정
    static func members(id:Int, nickname:String, email:String, httpMethod:HttpMethod = .patch, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["nickname": nickname, "email": email]
        let url = build(host:host, endpoint:"/members/\(id)", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // FCM 토큰 생성 및 갱신
    static func update_fcm_token(fcmToken:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["fcmToken": fcmToken]
        let url = build(host:host, endpoint:"/members/update-fcm-token", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원 포인트 조회
    static func point(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/point", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 탈퇴
    static func withdraw(responseType:String, reason:String, httpMethod:HttpMethod = .put, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["responseType": responseType, "reason": reason]
        let url = build(host:host, endpoint:"/members/withdraw", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원 신용카드 등록
    static func cards(cardNo:String, yearExpired:String, monthExpired:String, password:String, birthDate:String, name:String, defaultFlag:Bool, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["cardNo": cardNo, "yearExpired": yearExpired, "monthExpired":monthExpired,  "password":password, "birthDate":birthDate, "name":name, "defalutFlag":defaultFlag]
        let url = build(host:host, endpoint:"/members/cards", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원 신용카드 목록 조회
    static func cards(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/cards", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 신용카드 기본 설정
    static func cards(id:Int, httpMethod:HttpMethod = .patch, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/cards/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 신용카드 삭제
    static func delete_cards(id:Int, httpMethod:HttpMethod = .delete, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/cards/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 쿠폰 목록 조회
    static func coupons(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/coupons", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 차량 등록
    static func cars(modelId:Int, carNo:String, color:String, defaultFlag:Bool, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["modelId": modelId, "carNo": carNo, "color":color, "defalutFlag":defaultFlag]
        let url = build(host:host, endpoint:"/members/cars", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원 차량 목록 조회
    static func cars(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/cars", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 차량 기본설정
    static func cars(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
         let url = build(host:host, endpoint:"/members/cars/\(id)", params: nil)
         return (httpMethod, url, auth, nil)
    }
    
    // 회원 차량 삭제
    static func delete_cars(id:Int, httpMethod:HttpMethod = .delete, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/cars/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 주소 등록
    static func address(address:String, detail:String, latitude:String, longitude:String, type:AddressType, httpMethod:HttpMethod = .post, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["address": address, "detail": detail, "latitude": latitude, "longitude": longitude, "type":type.rawValue]
        let url = build(host:host, endpoint:"/members/address", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원 주소 목록 조회
    static func address(httpMethod:HttpMethod = .get, auth:APIAuthType = .OAuth2) -> RestURL  {
        let url = build(host:host, endpoint:"/members/cars", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 회원 주소 삭제
    static func delete_address(id:Int, httpMethod:HttpMethod = .delete, auth:APIAuthType = .OAuth2) -> RestURL  {
        let params:Params = ["id": id]
        let url = build(host:host, endpoint:"/members/cars", params: nil)
        return (httpMethod, url, auth, params)
    }
}
