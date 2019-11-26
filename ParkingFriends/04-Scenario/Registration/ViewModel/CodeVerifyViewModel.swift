//
//  PhoneNumberViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/20.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

protocol CodeVerifyViewModelType {
    var titleText: Driver<String> { get }
    var subtitleText: Driver<String> { get }
    
    var inputTitle: Driver<String> { get }
    var inputPlaceholder: Driver<String> { get }
    
    var nextText: Driver<String> { get }
}

class CodeVerifyViewModel: CodeVerifyViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    
    let inputTitle: Driver<String>
    let inputPlaceholder: Driver<String>
    
    let nextText: Driver<String>
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
     
    // MARK: - Initialize
     
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        let phoneNumber = PhoneNumberModel.formatted(RegistrationModel.shared.phoneNumber!)!
    
        titleText = localizer.localized("ttl_code_verify")
        subtitleText = localizer.localized("dsc_code_verify", arguments: phoneNumber)
            
        inputTitle = localizer.localized("ttl_code_verify_input")
        inputPlaceholder = localizer.localized("ph_code__verify_input")
        
        nextText = localizer.localized("btn_to_next")
    }
}
