//
//  MapType.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

enum MapOrders:String {
    case none = ""        
    case legalcode = "legalcode"            // 법정동
    case admcode = "admcode"                // 행정동
    case addr = "addr"                      // 지번주소
    case roadaddr = "roadaddr"              // 도로명주소
}

enum CoordSystemType:String {
    case epsg_4326 = "epsg:4326"
    case nhn_2048 = "nhn:2048"
    case nhn_128 = "nhn:128"
    case epsg_3857 = "epsg:3857"
}

enum GeoAddressType:String {
    case none = ""
    case sido = "SIDO"                               // 시도
    case sigugun = "SIGUGUN"                         // 시구군
    case dongmyun = "DONGMYUN"                       // 동면
    case ri = "RI"                                   // 리
    case road_name = "ROAD_NAME"                     // 도로명
    case building_number = "BUILDING_NUMBER"         // 건물 번호
    case building_name = "BUILDING_NAME"             // 건물 명
    case land_number = "LAND_NUMBER"                 // 지번
    case postal_code = "POSTAL_CODE"                 // 우편 번호
}

enum MapResultCode: String {
    case none = ""                             
    case okay = "OK"                             // 200
    case invalid_request = "INVALID_REQUEST"     // 400
    case system_error = "SYSTEM_ERROR"           // 500
}

enum OutputType: String {
    case json = "json"
    case xml = "xml"
}

// API 응답 코드
enum ErrorCodeType: Int {
    case bad_request_exception = 100
    case authentication_failed = 200
    case permission_denied = 210
    case not_found_exception = 300
    case quota_exceeded = 400
    case throttle_limited = 410
    case rate_limited = 420
    case request_entit_too_large = 430
    case endpoint_error = 500
    case endpoint_timeout = 510
    case unexpected_error = 900
}

enum APIErrorCodeType: Int {
    case invalid_request = 100
    case unknown_error = 900
}
