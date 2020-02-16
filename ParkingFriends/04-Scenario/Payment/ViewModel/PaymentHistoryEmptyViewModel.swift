//
//  PaymentHistoryEmptyViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentHistoryEmptyViewModelType {
    var emptyReservationTitleText: Driver<String> { get }
    var emptyReservationDescText: Driver<String> { get }
    var noUsedTicketTitleText: Driver<String> { get }
    var noUsedTicketDescText: Driver<String> { get }
}

class PaymentHistoryEmptyViewModel: PaymentHistoryEmptyViewModelType {
    var emptyReservationTitleText: Driver<String>
    var emptyReservationDescText: Driver<String>
    var noUsedTicketTitleText: Driver<String>
    var noUsedTicketDescText: Driver<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        emptyReservationTitleText = localizer.localized("ttl_payment_history_no_reserveration")
        emptyReservationDescText = localizer.localized("dsc_payment_history_no_reserveration")
        noUsedTicketTitleText = localizer.localized("ttl_payment_history_no_history")
        noUsedTicketDescText = localizer.localized("dsc_payment_history_no_history")
    }
}
