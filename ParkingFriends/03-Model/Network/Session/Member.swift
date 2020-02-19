//
//  Members.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class Member : HttpSession {
    // 회원 가입 : /v1/members
    static public func members(username:String, password:String, email:String, nickname:String, oldMemberId:Int, agreeMarketing:Bool) -> Observable<(Login?, ResponseCodeType)>  {
        let data = MembersAPI.members(username: username, password: password, email: email, nickname: nickname, oldMemberId: oldMemberId, agreeMarketing: agreeMarketing)
     
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Login(JSON: result.data), result.codeType)
            })
    }
    
    // 회원 상세 조회 : /v1/members
    static public func members() -> Observable<(Members?, ResponseCodeType)>  {
        let data = MembersAPI.members()
      
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Members(JSON: result.data), result.codeType)
            })
    }
    
    // 비밀번호 변경 : /v1/members/password
    static public func password(password:String, newPassword:String) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.password(password:password, newPassword:newPassword)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 휴대폰 번호 변경 : /v1/members/phone-number
    static public func phone_number(otp:String, otpId:String, phoneNumber:String) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.phone_number(otp: otp, otpId: otpId, phoneNumber: phoneNumber)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 정보 수정 : /v1/members/{id}
    static public func members(id:Int, nickname:String, email:String) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.members(id: id, nickname: nickname, email: email)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // FCM 토큰 생성 및 갱신 : /v1/members/update-fcm-token
    static public func update_fcm_token(fcmToken:String) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.update_fcm_token(fcmToken: fcmToken)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 포인트 조회 : /v1/members/point
    static public func point() -> Observable<(Point?, ResponseCodeType)>  {
        let data = MembersAPI.point()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Point(JSON: result.data), result.codeType)
            })
    }
    
    // 회원 탈퇴 : /v1/members/withdraw
    static public func withdraw(responseType:String, reason:String) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.withdraw(responseType: responseType, reason: reason)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 신용카드 등록 : /v1/members/cards
    static public func cards(cardNo:String, yearExpired:String, monthExpired:String, password:String, birthDate:String, realName:String) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.cards(cardNo: cardNo, yearExpired: yearExpired, monthExpired: monthExpired, password: password, birthDate: birthDate, realName: realName)
    
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 신용카드 목록 조회 : /v1/memberscards
    static public func cards() -> Observable<(Cards?, ResponseCodeType)>  {
        let data = MembersAPI.cards()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Cards(JSON: result.data), result.codeType)
            })
    }
    
    // 회원 신용카드 기본설정 : /v1/members/cards/{id}
    static public func cards(id:Int) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.cards(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 신용카드 삭제 : /v1/members/cards/{id}
    static public func delete_cards(id:Int) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.delete_cards(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 쿠폰 목록 조회 : /v1/members/coupons
    static public func coupons() -> Observable<(Coupons?, ResponseCodeType)>  {
        let data = MembersAPI.coupons()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Coupons(JSON: result.data), result.codeType)
            })
    }
    
    // 회원 차량 등록 : /v1/members/cars
    static public func cars(modelId:Int, carNo:String, color:String, defaultFlag: Bool) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.cars(modelId: modelId, carNo: carNo, color: color, defaultFlag: defaultFlag)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 차량 목록 조회: /v1/members/cars
    static public func cars() -> Observable<(Cars?, ResponseCodeType)>  {
        let data = MembersAPI.cars()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Cars(JSON: result.data), result.codeType)
            })
    }
    
    // 회원 차량 기본설정: /v1/members/cars/{id}
    static public func cars(id:Int) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.cards(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 차량 삭제: /v1/members/cars/{id}
    static public func delete_cars(id:Int) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.delete_cars(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 주소 등록: /v1/members/address
    static public func address(address:String, detail:String, latitude:String, longitude:String, type:AddressType) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.address(address: address, detail: detail, latitude:latitude, longitude:longitude, type: type)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 회원 주소 목록 조회: /v1/members/address
    static public func address() -> Observable<(Address?, ResponseCodeType)>  {
        let data = MembersAPI.address()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return (Address(JSON: result.data), result.codeType)
            })
    }
    
    static public func delete_address(id:Int) -> Observable<ResponseCodeType>  {
        let data = MembersAPI.delete_address(id: id)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params)
            .map ({  result in
                return result.codeType
            })
    }
}

