//
//  Type.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

typealias Params = [String : Any]

typealias CoordType = (latitude:CGFloat, longitude:CGFloat)

typealias FilterType = (fee:(from:Int, to:Int), lotType:String, option:(cctv:Bool, iotSensor:Bool, mechanical:Bool, allDayOperation:Bool))

enum Language:String {
    case korean = "ko"
    case english = "en"
}

enum HttpMethod:String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ContentType:String {
    case withdraw = "WITHDRAW"
    case suggest_type = "SUGGEST_TYPE"
    case faq = "FAQ"
    case product_type = "PRODUCT_TYPE"
}

enum TermsType: Int {
    case usage, personal_info, location_service, third_party_info, marketing_info
    case none
}

// 상품 유형 - ParkinglotsAPI
enum ProductType:String {
    case private_lot = "PRIVATE"
    case public_lot = "PUBLIC"
    case alliance = "ALLIANCE"
    case green = "GREEN"
    case resident = "RESIDENT"
}

// 추차장 유형 - ParkinglotsAPI
enum ParkingLotType:String {
    case time = "TIME"
    case fixed = "FIXED"
    case monthly = "MONTHLY"
}

enum SortType:String {
    case distance = "DISTANCE"
    case price = "PRICE"
}

// 회원 주소 등록
enum AddressType:String {
    case home = "HOME"
    case company = "COMPANY"
}

enum ResponseCodeType: String {
    case success = "0000"
    case not_found = "1404"
    case bad_request = "1400"
    case error_message = "1500"
    case unknown = ""
}

// 이메일, OTP 발송 상태, 입력 형식 체크 용 공통 타입
public enum CheckType {
    case none
    case valid          // 입력 형식 체크
    case invalid        // 입력 형식 잘못 됨
    case sent           // 발신 완료
    case verified       // 발신 결과 인증 됨
    case disproved      // 발신 결과 인증 안됨
}

