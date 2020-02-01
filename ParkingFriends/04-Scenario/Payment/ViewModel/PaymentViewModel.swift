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
    /*
    var paymentParkingInfoText: Driver<String> { get }
    var paymentMethodText: Driver<String> { get }
    var paymentSimpleCardText: Driver<String> { get }
    var paymentKakaoPayText: Driver<String> { get }
    var paymentNormalCardText: Driver<String> { get }
    var paymentPointText: Driver<String> { get }
    var paymentPointOwnedText: Driver<String> { get }
    var paymentNoPointText: Driver<String> { get }
    
    var paymentReminderText: Driver<String> { get }
    var paymentTotalPriceText: Driver<String> { get }
 */
}

class PaymentViewModel: PaymentViewModelType {
    var viewTitleText: Driver<String>
    var paymentParkingInfoText: Driver<String>
    var paymentMethodText: Driver<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_payment_for_parking")
        paymentParkingInfoText = localizer.localized("ttl_payment_parking_info")
        paymentMethodText = localizer.localized("ttl_payment_method")
    }
}
