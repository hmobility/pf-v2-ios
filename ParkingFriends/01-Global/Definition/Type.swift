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

typealias CardInfoType = (cardNo:String, yearExpired:String, monthExpired:String, password:String, birthDate:String)

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
    
    var index: Int {
        switch self {
        case .price:
            return 0
        case .distance:
            return 1
        }
    }
}

// 회원 주소 등록
enum AddressType:String {
    case home = "HOME"
    case company = "COMPANY"
}

// 주차장 상세 조회
enum OperationTimeType:String {
    case base = "BASE"
    case holiday = "HOLIDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"
}

// 영수증 공유
enum ReceiptSendType:String {
    case sms = "SMS"
    case kakao = "KAKAO"
    case email = "EMAIL"
}

// 포인트 충전
enum PaymentType: String {
    case card = "CARD"
    case mobile = "MOBILE"
}

// API 응답 코드
enum ResponseCodeType: String {
    case success = "0000"
    case not_found = "1404"
    case bad_request = "1400"
    case already_exist = "1403"
    case error_message = "1500"
    case unknown = ""
}

// 주문 상태 (주문 단일 조회)
enum OrderStatusType: String {
    case paid = "PAID"
    case canceled = "CANCELED"
    case used = "USED"
}

// 대체 주차장 조회
enum PartnerType: String {
    case partner_lot = "PARTNER"
    case public_lot = "PUBLIC"
}

// 약관 목록 조회 /v1/agreements
enum AgreementType: String {
    case location = "LOCATION"
    case access = "ACCESS"
    case privacy = "PRIVACY"
    case third = "THIRD"
    case marketing = "MARKETING"
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

