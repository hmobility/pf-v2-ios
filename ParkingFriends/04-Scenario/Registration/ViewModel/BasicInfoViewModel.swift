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
    var phoneNumberMessageText: BehaviorSubject<String> { get }
    
    var emailInputTitle: Driver<String> { get }
    var emailInputPlaceholder: Driver<String> { get }
    var emailMessageText: BehaviorSubject<String> { get }
    
    var passwordInputTitle: Driver<String> { get }
    var passwordInputPlaceholder: Driver<String> { get }
    var passwordMessageText: BehaviorSubject<String> { get }
    
    var nicknameInputTitle: Driver<String> { get }
    var nicknameInputPlaceholder: Driver<String> { get }
    var nicknameMessageText: BehaviorSubject<String> { get }
    
    var nextText: Driver<String> { get }
    
    //var proceed: BehaviorRelay<(BasicInfoSectionType, CheckType, String?)> { get }
    var proceed: BehaviorRelay<Bool> { get }
    
    var passwordModel:PasswordModel { get }
    
    func validate(section:BasicInfoSectionType) -> Bool 
}

class BasicInfoViewModel: BasicInfoViewModelType {
    var viewTitle: Driver<String>
    
    var phoneNumberInputTitle: Driver<String>
    var phoneNumberDisplayText: BehaviorSubject<String>
    var phoneNumberMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var emailInputTitle: Driver<String>
    var emailInputPlaceholder: Driver<String>
    var emailMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var passwordInputTitle: Driver<String>
    var passwordInputPlaceholder: Driver<String>
    var passwordMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var nicknameInputTitle: Driver<String>
    var nicknameInputPlaceholder: Driver<String>
    var nicknameMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var nextText: Driver<String>
    
  //  var proceed: BehaviorRelay<(BasicInfoSectionType, CheckType, String?)> = BehaviorRelay(value: (.none, .none, nil))
    var proceed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let emailModel = EmailModel()
    let nicknameModel = NicknameModel()
    let passwordModel = PasswordModel()
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared, phoneNumber:String) {
        self.localizer = localizer
        
        viewTitle = localizer.localized("ttl_basic_info")
        
        phoneNumberInputTitle = localizer.localized("ttl_input_phone_number")
        phoneNumberDisplayText = BehaviorSubject(value: phoneFormatter.format(phoneNumber)!)
        
        emailInputTitle = localizer.localized("ttl_input_email")
        emailInputPlaceholder = localizer.localized("ph_input_email")
        
        passwordInputTitle = localizer.localized("ttl_input_password")
        passwordInputPlaceholder = localizer.localized("ph_input_password")
        
        nicknameInputTitle = localizer.localized("ttl_input_nickname")
        nicknameInputPlaceholder = localizer.localized("phe_input_nickname")
        
        nextText = localizer.localized("btn_to_next")
    }
    
    // MARK: - Local Methods
    
    func updateStatus(_ status:CheckType, section:BasicInfoSectionType, message:String) {
        proceed.accept(validateCredentials())
    }
    
    // MARK: - Public Methods
    
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
    
    func validateCredentials() -> Bool {
        return validate(section: .email) && validate(section: .password) && validate(section: .nickname)
    }
    
    func checkCredential(_ type:AuthAccountType, value:String) {
        Auth.exist(type: type, value: value)
            .subscribe(onNext: { (existed:Bool, code) in
                print()
            })
            .disposed(by: disposeBag)
    }
}
