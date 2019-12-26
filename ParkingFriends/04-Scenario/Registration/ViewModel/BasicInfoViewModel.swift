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
    case none, phone_number, email, password, nickname
    
    static var allSections: [BasicInfoSectionType] {
        return [.phone_number, .email, .password, .nickname]
    }
}

protocol BasicInfoViewModelType {
    var viewTitle: Driver<String> { get }
    
    var phoneNumberInputTitle: Driver<String> { get }
    var phoneNumberDisplayText: BehaviorRelay<String> { get }
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
    
    //var proceed: BehaviorRelay<Bool> { get }
    var proceed: BehaviorRelay<(ProceedType, String)> { get }
    
   // var emailModel:EmailModel { get }
   // var nicknameModel:NicknameModel { get }
   // var passwordModel:PasswordModel { get }

  //  func validateCredentials() -> Bool
    func validateCredentials(section:UserInfoSectionType, editing:Bool) -> Bool
    func formatted(section:UserInfoSectionType, textField:UITextField, range:NSRange, replacement:String)
    func accept(_ text:String, section:UserInfoSectionType)
    func nextProcess()
}

class BasicInfoViewModel: BasicInfoViewModelType {
    var viewTitle: Driver<String>
    
    var phoneNumberInputTitle: Driver<String>
    var phoneNumberDisplayText: BehaviorRelay<String>
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
    
    //var proceed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var proceed: BehaviorRelay<(ProceedType, String)> = BehaviorRelay(value:(.none, ""))
    
    private let userInfoModel:UserInfoModelType
    
    let emailModel = EmailModel()
    let nicknameModel = NicknameModel()
    let passwordModel = PasswordModel()
    
    private var registrationMdoel: RegistrationModel
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared, phoneNumber:String, registration:RegistrationModel, userInfoModel:UserInfoModel = UserInfoModel()) {
        self.localizer = localizer
        self.registrationMdoel = registration
        self.userInfoModel = userInfoModel
        
        viewTitle = localizer.localized("ttl_basic_info")
        
        phoneNumberInputTitle = localizer.localized("ttl_input_phone_number")
        phoneNumberDisplayText = BehaviorRelay(value: phoneFormatter.format(phoneNumber)!)
    
        emailInputTitle = localizer.localized("ttl_input_email")
        emailInputPlaceholder = localizer.localized("ph_input_email")
        
        passwordInputTitle = localizer.localized("ttl_input_password")
        passwordInputPlaceholder = localizer.localized("ph_input_password")
        
        nicknameInputTitle = localizer.localized("ttl_input_nickname")
        nicknameInputPlaceholder = localizer.localized("ph_input_nickname")
        
        nextText = localizer.localized("btn_to_next")
        
        initialize()
    }
    
    func initialize() {
        if let phoneNumber = registrationMdoel.phoneNumber {
            userInfoModel.accept(phoneNumber, type: .phone_number)
        }
    }
    
    // MARK: - Local Methods
    
    func updateStatus(section:UserInfoSectionType, editing:Bool = false) -> Bool  {
        let result = userInfoModel.validate(type: section)
        let checkMessage = !editing || (result.check == .valid)
        
        if checkMessage {
            switch section {
            case .email:
                emailMessageText.accept(result.message)
            case .password:
                passwordMessageText.accept(result.message)
            case .nickname:
                nicknameMessageText.accept(result.message)
            default:
                break
            }
        }
        
        return (result.check == .valid)
    }

    func updateProcess(_ type:ProceedType) {
        switch type {
        case .none, .disabled:
            proceed.accept((type, ""))
        case .enabled:
            proceed.accept((.enabled, ""))
        case .success:
            //saveBasicInfo()
            proceed.accept((.success, ""))
        case .failure:
            let message = localizer.localized("msg_credit_card_invalid") as String
            proceed.accept((.failure, message))
        }
    }
    
    func nextProcess() {
        saveBasicInfo()
        self.updateProcess(.success)
    }
    
    func saveBasicInfo() {
        let uerInfo = userInfoModel.userData
        self.registrationMdoel.basicInfo(email: uerInfo.email, password: uerInfo.password, nickname: uerInfo.nickname)
    }
    
    func checkCredential(_ type:AuthAccountType, value:String) {
        Auth.exist(type: type, value: value)
            .subscribe(onNext: { (existed:Bool, code) in
                print()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public Methods
    
    func accept(_ text:String, section:UserInfoSectionType) {
        switch section {
        case .phone_number:
            _ = userInfoModel.accept(text, type:.phone_number)
        case .email:
            _ = userInfoModel.accept(text, type:.email)
        case .password:
            _ = userInfoModel.accept(text, type:.password)
        case .nickname:
            _ = userInfoModel.accept(text, type:.nickname)
        }
    }
    
    func formatted(section:UserInfoSectionType, textField:UITextField, range:NSRange, replacement:String) {
        switch section {
        case .phone_number:
            _ = userInfoModel.formatted(section:.phone_number, textField:textField, range:range, replacement:replacement)
        default:
            break
        }
        
        _ = self.validateCredentials(section:section, editing:true)
    }

    func validateCredentials(section:UserInfoSectionType, editing:Bool = false) -> Bool {
        let sections = UserInfoSectionType.checkSections.filter { $0 != section }
        var result = false
        
        if updateStatus(section: section, editing:editing) == true {
            for sectionType in sections {
                result = updateStatus(section: sectionType)
                
                if result == false {
                    break
                }
            }
        }
        
        updateProcess(result ? .enabled : .disabled)
        
        return result
    }
}
