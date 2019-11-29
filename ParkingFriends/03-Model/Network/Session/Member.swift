//
//  Members.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class Member : HttpSession {
    // 회원가입 : /v1/members
    static public func members(username:String, password:String, email:String, nickname:String, oldMemberId:Int, agreeMarketing:Bool) -> Observable<(Login?, ResponseCodeType)>  {
        let data = MembersAPI.members(username: username, password: password, email: email, nickname: nickname, oldMemberId: oldMemberId, agreeMarketing: agreeMarketing)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Login(JSON: result.data!), result.codeType)
            })
    }
}

