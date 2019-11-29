//
//  BasicInfoViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

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
    
    var proceed: BehaviorRelay<(CheckType, String?)> { get }
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
    
    var proceed: BehaviorRelay<(CheckType, String?)> = BehaviorRelay(value: (.none, nil))
    
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
    
    
    func updateStatus() {
    }
}
