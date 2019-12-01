//
//  Auth.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/22.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class Auth : HttpSession {
    
    // 로그인 : /v1/auth/login
    static public func login(username:String, password:String) -> Observable<(Login?, ResponseCodeType)> {
        let data = AuthAPI.login(username: username, password: password)

        return self.shared.dataTask(httpMethod: data.method, auth: data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Login(JSON: result.data!), result.codeType)
            })
    }
    
    // 로그인
    static public func login(username:String, password:String, completion:@escaping(_ data:Login?, _ message:String?) -> Void) {
        let data = AuthAPI.login(username: username, password: password)

        _ = self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!, completion:{(response, message, code) in
            if let result = response {
                let object = Login(JSON: result)
                completion(object, message)
            } else {
                completion(nil, message)
            }
        }, failure: { message in
            
        })
    }
    
    // 로그아웃 : /v1/auth/logout
    static public func logout() -> Observable<(ResponseCodeType)> {
        let data = AuthAPI.logout()

        return self.shared.dataTask(httpMethod: data.method, auth: data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func logout(username:String, password:String, completion:@escaping(_ completed:Bool, _ message:String?) -> Void) {
        let data = AuthAPI.login(username: username, password: password)
        
        _ = self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!, completion:{(response, message, code) in
            if response != nil {
                completion(true, message)
            } else {
                completion(false, message)
            }
        }, failure: { message in
            
        })
    }
    
    // 아이디/비밀번호 찾기 이메일 전송 /v1/auth/email
    static public func email(type:AuthEmailType, email:String, completion:@escaping(_ completed:Bool, _ message:String?) -> Void) {
        let data = AuthAPI.email(type: type, email:email)
         
        _ = self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!, completion: {(response, message, code) in
            if response != nil {
                completion(true, message)
            } else {
                completion(false, message)
            }
         }, failure: { message in
             
         })
     }

    // 휴대폰 OTP 전송 : /v1/auth/otp
    static public func otp(phoneNumber:String) -> Observable<(Otp?, ResponseCodeType)> {
        let data = AuthAPI.otp(phoneNumber: phoneNumber)
        
        return self.shared.dataTask(httpMethod: data.method, auth: data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Otp(JSON: result.data!), result.codeType)
            })
    }

    // 휴대폰 OTP 확인 : /v1/auth/otp/check
    static public func otp_check(phoneNumber:String, otp:String, otpId:Int) -> Observable<ResponseCodeType>  {
        let data = AuthAPI.otp_check(phoneNumber: phoneNumber, otp: otp, otpId: otpId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 중복확인(아이디, 이메일, 닉네임) : /v1/auth/exist
    static public func exist(type:AuthAccountType, value:String) -> Observable<(exist:Bool, ResponseCodeType)>  {
        let data = AuthAPI.exist(type:type, value:value)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (exist: Bool((result.data!["data"] as! String)), result.codeType)
            })
    }
}
