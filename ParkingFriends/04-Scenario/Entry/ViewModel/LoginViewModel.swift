//
//  LoginViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewModelType {
    var accountPlaceholder: Observable<String> { get }
    var passwordPlaceholder: Observable<String> { get }
    var loginText: Observable<String> { get }
    var changePhoneNumberText: Observable<String> { get }
    var findPasswordText: Observable<String> { get }
    
    var phoneNumberModel:PhoneNumberModel { get }
    var passwordModel:PasswordModel { get }
    
    func validateCredentials() -> Bool
}

class LoginViewModel: LoginViewModelType {
    var accountPlaceholder: Observable<String>
    var passwordPlaceholder: Observable<String>
    var loginText: Observable<String>
    var changePhoneNumberText: Observable<String>
    var findPasswordText: Observable<String>
    
    var phoneNumberModel = PhoneNumberModel()
    var passwordModel = PasswordModel()
    
    init(localizer: LocalizerType = Localizer.shared) {
        accountPlaceholder = Observable.just(localizer.localized("account_input_placeholder"))
        passwordPlaceholder = Observable.just(localizer.localized("password_input_placeholder"))
        loginText = Observable.just(localizer.localized("login"))
        changePhoneNumberText = Observable.just(localizer.localized("change_phone_number"))
        findPasswordText = Observable.just(localizer.localized("find_password"))
    }
    
    func validateCredentials() -> Bool {
        return true// phoneNumberModel.validateCredentials() && passwordModel.validateCredentials()
    }
}
