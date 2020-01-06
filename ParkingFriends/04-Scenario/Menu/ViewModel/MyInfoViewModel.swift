//
//  MyInfoViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol MyInfoViewModelType {
    var viewTitle: Driver<String> { get }
    
    var phoneNumberInputTitle: Driver<String> { get }
    var phoneNumberPlaceholder: Driver<String> { get }
    var phoneNumberMessageText: BehaviorRelay<String> { get }
    
    var emailInputTitle: Driver<String> { get }
    var emailInputPlaceholder: Driver<String> { get }
    var emailMessageText: BehaviorRelay<String> { get }
    
    var nicknameInputTitle: Driver<String> { get }
    var nicknameInputPlaceholder: Driver<String> { get }
    var nicknameMessageText: BehaviorRelay<String> { get }
    
    var saveText: Driver<String> { get }
    

}

class MyInfoViewModel: MyInfoViewModelType {
    var viewTitle: Driver<String>
    
    var phoneNumberInputTitle: Driver<String>
    var phoneNumberPlaceholder: Driver<String>
    var phoneNumberMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var emailInputTitle: Driver<String>
    var emailInputPlaceholder: Driver<String>
    var emailMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var nicknameInputTitle: Driver<String>
    var nicknameInputPlaceholder: Driver<String>
    var nicknameMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var saveText: Driver<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitle = localizer.localized("ttl_my_info")
            
        phoneNumberInputTitle = localizer.localized("ttl_input_phone_number")
        phoneNumberPlaceholder = localizer.localized("ttl_input_phone_number")
        
        emailInputTitle = localizer.localized("ttl_input_email")
        emailInputPlaceholder = localizer.localized("ph_input_email")
        
        nicknameInputTitle = localizer.localized("ttl_input_nickname")
        nicknameInputPlaceholder = localizer.localized("ph_input_nickname")
        
        saveText = localizer.localized("btn_save_to_changed")
    }
}
