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
    
    var carModel: CarModelsElement? { get set }
    var carBrand: CarBrandsElement? { get set }
    var carNumber: String? { get set }
    var carColor: String? { get set }
    
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
    
    var carModel: CarModelsElement?
    var carBrand: CarBrandsElement?
    
    var carNumber: String?
    var carColor: String?
    
    static let shared: RegistrationModel = {
        let instance = RegistrationModel()
        return instance
    }()
    
    private init() {
    }
    
    // MARK: - Local Methods
    
    // MARK: - Public Methods
    
    // MARK: - Car Info
    
    public func setCarModel(_ model:CarModelsElement, brand:CarBrandsElement) {
        self.carModel = model
        self.carBrand = brand
    }
    
    public func setCarColor(_ color:String) {
        self.carColor = color
    }
    
    public func setCarNumber(_ number:String) {
        self.carNumber = number
    }
    
    // MARK: - Basic Info
    
    public func basicInfo(email:String, password:String, nickname:String) {
        self.email = email
        self.password = password
        self.nickname = nickname
    }
    
    public func resetBasicInfo() {
        self.email = nil
        self.password = nil
        self.nickname = nil
    }
    
    // MARK: - OTP
    
    public func otp(_ otp:Otp, phoneNumber:String) {
        self.otp = otp
        self.phoneNumber = phoneNumber
    }
    
    public func resetOtp(numberReset reset:Bool = false) {
        self.otp = nil
        
        if reset {
            self.phoneNumber = nil
        }
    }
}
