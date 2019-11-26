//
//  RegistrationModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/21.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation


public protocol RegistrationModelType {
    var phoneNumber: String? { get set }
    var email: String? { get set }
    var nickname: String? { get set }
    var otpId: String? { get set }
    var isThirdPartyAgrrement: Bool { get set }
    
    var otp:Otp? { get set }
}

final class RegistrationModel {
    var phoneNumber:String?
    var email:String?
    var nickname:String?
    var isThirdPartyAgrrement:Bool = false
    
    var otp:Otp?
    
    static let shared = RegistrationModel()
    
    private init() {
    }
}
