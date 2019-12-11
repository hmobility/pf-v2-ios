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
    var password:String? { get set }
    var isThirdPartyAgrrement: Bool { get set }
    
    var otp:Otp? { get set }
    
    func otp(_ otp:Otp, phoneNumber:String)
    func resetOtp()
}

final class RegistrationModel {
    var phoneNumber:String?
    var email:String?
    var nickname:String?
    var password:String?
    var isThirdPartyAgreement:Bool = false
    
    var otp:Otp?
    var checkOldMember:OldMember?
    
    static let shared: RegistrationModel = {
        let instance = RegistrationModel()
        return instance
    }()
    
    private init() {
    }
    
    func basicInfo(email:String, password:String, nickname:String) {
        self.email = email
        self.password = password
        self.nickname = nickname
    }
    
    func resetBasicInfo() {
        self.email = nil
        self.password = nil
        self.nickname = nil
    }
    
    func otp(_ otp:Otp, phoneNumber:String) {
        self.otp = otp
        self.phoneNumber = phoneNumber
    }
    
    func resetOtp(numberReset reset:Bool = false) {
        self.otp = nil
        
        if reset {
            self.phoneNumber = nil
        }
    }
}
