//
//  BasicInfoViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

public enum BasicInfoSectionType {
    case none
    case phone_number
    case email
    case password
    case nickname
}

protocol BasicInfoViewModelType {
    var viewTitle: Driver<String> { get }
    
    var phoneNumberInputTitle: Driver<String> { get }
    var phoneNumberDisplayText: BehaviorSubject<String> { get }
    var phoneNumberMessageText: BehaviorRelay<String> { get }
    
    var emailInputTitle: Driver<String> { get }
    var emailInputPlaceholder: Driver<String> { get }
    var emailMessageText: BehaviorRelay<String> { get }
    
    var passwordInputTitle: Driver<String> { get }
    var passwordInputPlaceholder: Driver<String> { get }
    var passwordMessageText: BehaviorRelay<String> { get }
    
    var nicknameInputTitle: Driver<String> { get }
    var nicknameInputPlaceholder: Driver<String> { get }
    var nicknameMessageText: BehaviorRelay<String> { get }
    
    var nextText: Driver<String> { get }
    
    var proceed: BehaviorRelay<Bool> { get }
    
    var emailModel:EmailModel { get }
    var nicknameModel:NicknameModel { get }
    var passwordModel:PasswordModel { get }

   // func validate(section:BasicInfoSectionType) -> Bool
    func validateCredentials() -> Bool
    func saveBasicInfo()
}

class BasicInfoViewModel: BasicInfoViewModelType {
    var viewTitle: Driver<String>
    
    var phoneNumberInputTitle: Driver<String>
    var phoneNumberDisplayText: BehaviorSubject<String>
    var phoneNumberMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var emailInputTitle: Driver<String>
    var emailInputPlaceholder: Driver<String>
    var emailMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var passwordInputTitle: Driver<String>
    var passwordInputPlaceholder: Driver<String>
    var passwordMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var nicknameInputTitle: Driver<String>
    var nicknameInputPlaceholder: Driver<String>
    var nicknameMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var nextText: Driver<String>
    
  //  var proceed: BehaviorRelay<(BasicInfoSectionType, CheckType, String?)> = BehaviorRelay(value: (.none, .none, nil))
    var proceed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let emailModel = EmailModel()
    let nicknameModel = NicknameModel()
    let passwordModel = PasswordModel()
    
    var registrationMdoel: RegistrationModel
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared, phoneNumber:String, registration:RegistrationModel) {
        self.localizer = localizer
        self.registrationMdoel = registration
        
        viewTitle = localizer.localized("ttl_basic_info")
        
        phoneNumberInputTitle = localizer.localized("ttl_input_phone_number")
        phoneNumberDisplayText = BehaviorSubject(value: phoneFormatter.format(phoneNumber)!)
        
        emailInputTitle = localizer.localized("ttl_input_email")
        emailInputPlaceholder = localizer.localized("ph_input_email")
        
        passwordInputTitle = localizer.localized("ttl_input_password")
        passwordInputPlaceholder = localizer.localized("ph_input_password")
        
        nicknameInputTitle = localizer.localized("ttl_input_nickname")
        nicknameInputPlaceholder = localizer.localized("ph_input_nickname")
        
        nextText = localizer.localized("btn_to_next")
    }
    
    // MARK: - Local Methods
    
    func updateStatus(_ status:CheckType, section:BasicInfoSectionType, message:String) {
        switch section {
        case .email:
            emailMessageText.accept(message)
        case .password:
            passwordMessageText.accept(message)
        case .nickname:
            nicknameMessageText.accept(message)
        default:
            break
        }
    }
    
    func validate(section:BasicInfoSectionType) -> Bool {
        switch section {
        case .email:
            let result = emailModel.validateCredentials()
            let status:CheckType = result ? .valid : .invalid
            updateStatus(status, section: .email, message: emailModel.message(status))
            return result
        case .password:
            let result =  passwordModel.validateCredentials()
            let status:CheckType = result ? .valid : .invalid
            updateStatus(status, section: .password, message: passwordModel.message(status))
            return result
        case .nickname:
            let result = nicknameModel.validateCredentials()
            let status:CheckType = result ? .valid : .invalid
            updateStatus(status, section: .nickname, message: passwordModel.message(status))
            return result
        default:
            break
        }
        
        return false
    }
    
    // MARK: - Public Methods
    
    func validateCredentials() -> Bool {
        let result = validate(section: .email) && validate(section: .password) && validate(section: .nickname)
        proceed.accept(result)
        
        return result
    }
    
    func saveBasicInfo() {
        let email = emailModel.data.value
        let password = passwordModel.data.value
        let nickname = nicknameModel.data.value
        
        self.registrationMdoel.basicInfo(email: email, password: password, nickname: nickname)
    }
    
    func checkCredential(_ type:AuthAccountType, value:String) {
        Auth.exist(type: type, value: value)
            .subscribe(onNext: { (existed:Bool, code) in
                print()
            })
            .disposed(by: disposeBag)
    }
}
