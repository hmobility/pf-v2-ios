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

class ServerResult: BaseModelType {
    var code: String = ""
    var message:String = ""
    var data:[String:Any] = [:]
    
    var codeType: ResponseCodeType {
        get {
            return ResponseCodeType(rawValue: code)
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
    /*
    var error_message: String {
        switch errorCode {
        case 200: // GET, PUT, POST 연동 성공시
            return "GET, PUT, POST 연동 성공시"
        case 201: // 신규 데이터 인스턴스가 생성된 경우
            return "신규 데이터 인스턴스가 생성된 경우"
        case 204: // 응답할 내용이 없는 경우, 일반적으로 DELETE 연동 성공시 사용
            return "응답할 내용이 없는 경우, 일반적으로 DELETE 연동 성공시 사용"
        case 304: // 클라이언트가 캐시에 응답을 이미 수신한 경우, 동일한 데이터를 다시 전송할 필요가 없는 경우 사용
            return "클라이언트가 캐시에 응답을 이미 수신한 경우, 동일한 데이터를 다시 전송할 필요가 없는 경우 사용"
        case 400: // 클라이언트 요청이 잘못되어 응답할 수 없는 경우
            return "클라이언트 요청이 잘못되어 응답할 수 없는 경우"
        case 401: // 클라이언트가 인증되지 않고 리소스에 접근 요청한 경우
            return "클라이언트가 인증되지 않고 리소스에 접근 요청한 경우"
        case 403: // 클라이언트 인증은 유효하지만, 해당 리소스에 대한 접근 권한이 없는 경우
            return "클라이언트 인증은 유효하지만, 해당 리소스에 대한 접근 권한이 없는 경우"
        case 404: // 클라이언트가 요청한 리소스가 존재하지 않는 경우
            return "클라이언트가 요청한 리소스가 존재하지 않는 경우"
        case 410: // 클라이언트가 요청한 리소스가 변경되어 더 이상 유효하지 않은 경우
            return "클라이언트가 요청한 리소스가 변경되어 더 이상 유효하지 않은 경우"
        case 500: // 서버 내부적으로 처리되지 않은 에러가 발생한 경우
            return "서버 내부적으로 처리되지 않은 에러가 발생한 경우"
        case 503: // 서버가 다운되었거나 서비스가 응답을 하지 않는 경우
            return "서버가 다운되었거나 서비스가 응답을 하지 않는 경우"
        default:
            return ""
        }

        return ""
    }
 */
 
}

