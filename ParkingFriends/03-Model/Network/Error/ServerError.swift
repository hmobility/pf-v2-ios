//
//  ErrorMessage.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/17.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ServerError: BaseModel {
    var status: String = ""
    var errorCode: Int = 0
    var path:String = ""
    var exception:String = ""
    var message:String = ""
    var timestamp:String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        print(">> \(map.JSON)")
        status <- map["status"]
        errorCode <- map["errorCode"]
        path <- map["path"]
        exception <- map["exception"]
        message <- map["message"]
        timestamp <- map["timestamp"]
    }
    
    var error_message: String {
        /*
        switch errorCode {
        case 1015: // 사용자의 상태가 관리자에 의해 정지 되었을 때
            return LanguageManager.shared.selectedScript!.login.block_alert
        case 1016: // 사용자의 상태가 관리자에 의해 논리적으로 삭제되었을 때
            return LanguageManager.shared.selectedScript!.login.rgstr_alert
        case 1500: // 중복로그인
            return LanguageManager.shared.selectedScript!.login.multiblock
        case 2002: // 태넌트의 계약기간이 만료되었을 때
            return LanguageManager.shared.selectedScript!.login.expired_alert
        case 2015: // 태넌트의 상태가 관리자에 의해 정지되었을 때
            return LanguageManager.shared.selectedScript!.login.block_alert
        case 2016: // 태넌트의 상태가 관리자에 의해 논리적으로 삭제되었을 때
            return LanguageManager.shared.selectedScript!.login.companycode_alert2
        default:
            return ""
        }
         */
        return ""
    }
 
}

