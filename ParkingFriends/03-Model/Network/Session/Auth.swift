//
//  Auth.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/22.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class Auth : HttpSession {
    static public func login(username:String, password:String, completion:@escaping(_ data:Login?, _ message:String) -> Void) {
        let data = AuthAPI.login(username: username, password: password)

        _ = self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!) {(response, message) in
                if let result = response {
                    let object = Login(JSON: result)
                    completion(object, message)
                }
        }
    }
    
    static public func logout(username:String, password:String, completion:@escaping(_ complete:Bool, _ message:String) -> Void) {
        let data = AuthAPI.login(username: username, password: password)
        
        _ = self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!) {(response, message) in
                if let result = response {
                    completion(true, message)
                }
        }
    }
}
