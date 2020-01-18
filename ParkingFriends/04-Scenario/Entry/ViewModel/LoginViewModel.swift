//
//  LoginViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift


public enum VerificationError: Error {
    case phoneNumber
    case password
    case badCredentials
}

// 로그인 시 폰/이메일 인증 할 때 사용
public enum VerificationStatus {
    case none
    case error(VerificationError)
    case verified
}

protocol LoginViewModelType {
    var phoneNumberPlaceholder: Driver<String> { get }
    var passwordPlaceholder: Driver<String> { get }
    
    var loginText: Driver<String> { get }
    var changePhoneNumberText: Driver<String> { get }
    var findPasswordText: Driver<String> { get }
    
    var phoneNumberModel:PhoneNumberModel { get }
    var passwordModel:PasswordModel { get }
    
    var loginStatus:BehaviorRelay<VerificationStatus> { get set }
    
    func validateCredentials()
}

class LoginViewModel: LoginViewModelType {
    var phoneNumberPlaceholder: Driver<String>
    var passwordPlaceholder: Driver<String>
    
    var loginText: Driver<String>
    var changePhoneNumberText: Driver<String>
    var findPasswordText: Driver<String>
    
    let phoneNumberModel = PhoneNumberModel()
    let passwordModel = PasswordModel()
    
    var loginStatus:BehaviorRelay<VerificationStatus> = BehaviorRelay(value:.none)
    
    private let disposeBag = DisposeBag()
    
    init(localizer: LocalizerType = Localizer.shared) {
        phoneNumberPlaceholder = localizer.localized("ph_input_phone_number")
        passwordPlaceholder = localizer.localized("ph_input_password")
        loginText = localizer.localized("btn_login")
        changePhoneNumberText = localizer.localized("btn_phone_number_change")
        findPasswordText = localizer.localized("btn_password_find")
    }
    
    // MARK: - Local Methods
    
    private func updateStatus(_ status:VerificationStatus) {
        self.loginStatus.accept(status)
    }
    
    // MARK: - Public Methods
    
    func validateCredentials() {
        if phoneNumberModel.validatePattern() == false {
            updateStatus(.error(.phoneNumber))
            return
        }
            
        if passwordModel.validateCredentials() == false {
            updateStatus(.error(.password))
            return
        }
        
        if let number = phoneNumberModel.phoneNumber {
            checkCredentials(username: number, password: passwordModel.data.value)
        }
    }
    
    func checkCredentials(username:String, password:String) {
        debugPrint("[USERNAME] ", username, " , [PASSWORD] ", password)
        Auth.login(username: username, password: password).subscribe(onNext: { (login, code) in
            if code == .success {
                self.updateStatus(.verified)
                _ = UserData.shared.setAuth(login).save()
            } else {
                self.updateStatus(.error(.badCredentials))
            }
            }, onError: { error in
            
            })
            .disposed(by: disposeBag)
    }
}
