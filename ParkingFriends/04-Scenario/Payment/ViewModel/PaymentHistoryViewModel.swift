//
//  PaymentHistoryViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentHistoryViewModelType {
    var viewTitleText: Driver<String> { get }
    var ticketUsedTitleText: String { get }
    var ticketNotUsedTitleText: String { get }
    
    func getTapItems() -> Observable<[String]>
}

class PaymentHistoryViewModel: PaymentHistoryViewModelType {
    var viewTitleText: Driver<String>
    var ticketUsedTitleText: String
    var ticketNotUsedTitleText: String
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    
        viewTitleText = localizer.localized("ttl_payment_for_parking")
        ticketUsedTitleText = localizer.localized("ttl_payment_history_not_used")
        ticketNotUsedTitleText = localizer.localized("ttl_payment_history_used")
    }
    
    // MARK: - Public Methods
    
    public func getTapItems() -> Observable<[String]> {
        return Observable.of([ticketUsedTitleText, ticketNotUsedTitleText])
    }
}