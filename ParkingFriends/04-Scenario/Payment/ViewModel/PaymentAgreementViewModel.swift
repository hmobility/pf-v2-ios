
//
//  PaymentAgreementViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/03/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentAgreementViewModelType {
    var agreementGuideText: Driver<String> { get }
    var agreementText: Driver<String> { get }
    
    var agreementCheckState:BehaviorRelay<Bool> { get }
}

class PaymentAgreementViewModel: PaymentAgreementViewModelType {
    var agreementGuideText: Driver<String>
    var agreementText: Driver<String>
    
    var agreementCheckState:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        agreementGuideText = localizer.localized("txt_payment_reminder_guide")
        agreementText = localizer.localized("ttl_payment_reminder")
    }
}
