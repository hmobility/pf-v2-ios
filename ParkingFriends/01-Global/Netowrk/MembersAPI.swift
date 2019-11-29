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
    static func members(id:Int, httpMethod:HttpMethod = .get, auth:APIAuthType = .serviceKey) -> RestURL  {
        let url = build(host:host, endpoint:"/members/\(id)", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 비밀번호 변경
    static func password(id:Int, httpMethod:HttpMethod = .patch, auth:APIAuthType = .serviceKey) -> RestURL  {
        let url = build(host:host, endpoint:"/members/\(id)/password", params: nil)
        return (httpMethod, url, auth, nil)
    }
    
    // 휴대폰 번호 변경
    static func phone_number(id:Int, otp:String, otpId:String, phoneNumber:String, httpMethod:HttpMethod = .patch, auth:APIAuthType = .serviceKey) -> RestURL  {
        let params:Params = ["otp": otp, "otpId": otpId, "phoneNumber": phoneNumber]
        let url = build(host:host, endpoint:"/members/\(id)/phone-number", params: nil)
        return (httpMethod, url, auth, params)
    }
    
    // 회원정보 수정
    static func change(id:Int, nickname:String, email:String, httpMethod:HttpMethod = .patch, auth:APIAuthType = .serviceKey) -> RestURL  {
        let params:Params = ["nickname": nickname, "email": email]
        let url = build(host:host, endpoint:"/members/\(id)", params: nil)
        return (httpMethod, url, auth, params)
    }
}
