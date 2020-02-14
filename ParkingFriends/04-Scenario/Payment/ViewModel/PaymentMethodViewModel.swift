//
//  PaymentMethodViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol PaymentMethodViewModelType {
    var titleText: Driver<String> { get }
    var simpleCardText: Driver<String> { get }
    var kakaoPayText: Driver<String> { get }
    var etcPaymentText: Driver<String> { get }
}

class PaymentMethodViewModel: PaymentMethodViewModelType {
    var titleText: Driver<String>
    var simpleCardText: Driver<String>
    var kakaoPayText: Driver<String>
    var etcPaymentText: Driver<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        titleText = localizer.localized("ttl_payment_for_parking")
        simpleCardText = localizer.localized("txt_payment_simple_card")
        kakaoPayText = localizer.localized("txt_payment_kakao_pay")
        etcPaymentText = localizer.localized("txt_payment_etc_payment")
    }
}
