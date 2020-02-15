//
//  PaymentViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/29.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentViewModelType {
    var viewTitleText: Driver<String> { get }
    var paymentText: BehaviorRelay<String> { get }
    
    func setGiftMode(_ flag:Bool)
}

class PaymentViewModel: PaymentViewModelType {
    var viewTitleText: Driver<String>
    var paymentText: BehaviorRelay<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
     
        viewTitleText = localizer.localized("ttl_payment_for_parking")
        paymentText = BehaviorRelay(value: localizer.localized("btn_to_pay"))
    }
    
    // MARK: - Public Methods
    
    public func setGiftMode(_ flag:Bool) {
        if flag {
            paymentText.accept(localizer.localized("btn_to_pay"))
        } else {
            paymentText.accept(localizer.localized("btn_to_pay"))
        }
    }
}
