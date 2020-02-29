
//
//  ReserveCancelViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/09.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ReserveCancelViewModelType {
    var viewTitleText: Driver<String> { get }
    
    var paymentFieldText: Driver<String> { get }
    var paymentPriceText: BehaviorRelay<String> { get }
    
    var cancelFeeFieldText: Driver<String> { get }
    var cancelFeeFreeText: Driver<String> { get }
    var cancelFeePriceText: BehaviorRelay<String> { get }
    
    var refundPriceFieldText: Driver<String> { get }
    var refundPriceText: BehaviorRelay<String> { get }
    
    var cancelText: Driver<String> { get }
    var confirmText: Driver<String> { get }
}

class ReserveCancelViewModel: ReserveCancelViewModelType {
    
    var viewTitleText: Driver<String>
      
    var paymentFieldText: Driver<String>
    var paymentPriceText: BehaviorRelay<String>
    
    var cancelFeeFieldText: Driver<String>
    var cancelFeeFreeText: Driver<String>
    var cancelFeePriceText: BehaviorRelay<String>
    
    var refundPriceFieldText: Driver<String>
    var refundPriceText: BehaviorRelay<String>
    
    var cancelText: Driver<String>
    var confirmText: Driver<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
 
        viewTitleText = localizer.localized("ttl_reservation_cancel")
          
        paymentFieldText = localizer.localized("txt_payment_price")
        paymentPriceText = BehaviorRelay(value:"")
        
        cancelFeeFieldText = localizer.localized("txt_cancellation_price")
        cancelFeeFreeText = localizer.localized("txt_cancellation_price")
        cancelFeePriceText = BehaviorRelay(value:"")
        
        refundPriceFieldText = localizer.localized("txt_refund_price")
        refundPriceText = BehaviorRelay(value:"")
        
        cancelText = localizer.localized("btn_no")
        confirmText = localizer.localized("btn_yes")
    }
}
