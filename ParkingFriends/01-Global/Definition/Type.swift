//
//  Type.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/25.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

typealias Params = [String : Any]

typealias CoordType = (latitude:Double, longitude:Double)

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

// 추차장 유형 - ParkinglotsAPI
enum ParkingLotType:String {
    case private_lot = "PRIVATE"
    case public_lot = "PUBLIC"
    case alliance = "ALLIANCE"
    case green = "GREEN"
    case resident = "RESIDENT"
}

// 상품 유형 - ParkinglotsAPI
enum ProductType:String {
    case time = "TIME"
    case fixed = "FIXED"
    case monthly = "MONTHLY"
}

enum SortType:String {
    case distance = "DISTANCE"
    case price = "PRICE"
    
    init(index: Int) {
        switch index {
        case 0:
            self = .price
        case 1:
            self = .distance
        default:
            self = .price
        }
    }
    
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
public enum ResponseCodeType: String {
    case success = "0000"
    case unauthorized = "1401"
    case bad_request = "1400"
    case already_exist = "1403"
    case not_found = "1404"
    case error_message = "1500"
    case unknown = ""
    
    public init(rawValue: String) {
        switch rawValue {
        case "0000": self = .success
        case "1400": self = .bad_request
        case "1401": self = .unauthorized
        case "1403": self = .already_exist
        case "1404": self = .not_found
        case "1500": self = .error_message
        default: self = .unknown
        }
    }
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

// 이메일, OTP 발송 상태, 입력 형식 등 체크 용 공통 타입
public enum CheckType {
    case none
    case valid          // 입력 형식 체크
    case invalid        // 입력 형식 잘못 됨
    case sent           // 발신 완료
    case verified       // 발신 결과 인증 됨
    case disproved      // 발신 결과 인증 안됨
}

public enum ProceedType {
    case none           // 초기 상태
    case disabled       // 버튼 상태 (disabled)
    case enabled        // 버튼 상태 (enabled)
    case success        // 네트워크 호출 후 전송 완료
    case failure        // 네트워크 호출 후 실패
}

// Color Type

enum ColorType {
    case white, black, dark_gray, silver, blue, red, gold, blue_green, dark_green, brown, sky_blue
    
    var rawValue: String {
        switch self {
        case .white: return "itm_white"
        case .black: return "itm_black"
        case .dark_gray: return "itm_dark_gray"
        case .silver: return "itm_silver"
        case .blue: return "itm_blue"
        case .red: return "itm_red"
        case .gold: return "itm_gold"
        case .blue_green: return "itm_blue_green"
        case .dark_green: return "itm_dark_green"
        case .brown: return "itm_brown"
        case .sky_blue: return "itm_sky_blue"
        }
    }
    
    var imgValue: String {
        switch self {
        case .white: return "imgCarcolorPaletteWhite"
        case .black: return "imgCarcolorPaletteBlack"
        case .dark_gray: return "imgCarcolorPaletteDarkgray"
        case .silver: return "imgCarcolorPaletteSilver"
        case .blue: return "imgCarcolorPaletteBlue"
        case .red: return "imgCarcolorPaletteRed"
        case .gold: return "imgCarcolorPaletteGold"
        case .blue_green: return "imgCarcolorPaletteBluegreen"
        case .dark_green: return "imgCarcolorPaletteDarkgreen"
        case .brown: return "imgCarcolorPaletteBrown"
        case .sky_blue: return "imgCarcolorPaletteSkyblue"
        }
    }
    
    public var image: UIImage {
        return UIImage(named: imgValue)!
    }
}


// 사용자 레벨 타입
public enum PointLevelType: Int {
    case level_1 = 1, level_2, level_3, level_4, level_5
}
