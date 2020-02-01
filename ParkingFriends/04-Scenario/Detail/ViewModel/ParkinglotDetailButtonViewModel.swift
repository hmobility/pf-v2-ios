//
//  ParkinglotDetailButtonViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailButtonViewModelType {
    var disabledReserveButtonText: Driver<String> { get }
    var giftButtonText: Driver<String> { get }
    var reserveButtonText: Driver<String> { get }
    
    var bookableState: BehaviorRelay<Bool> { get }
    
    func setBookableState(_ flag:Bool)
}

class ParkinglotDetailButtonViewModel: ParkinglotDetailButtonViewModelType {
    var disabledReserveButtonText: Driver<String>
    var giftButtonText: Driver<String>
    var reserveButtonText: Driver<String>
    
    var bookableState: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private var localizer:LocalizerType
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        disabledReserveButtonText = localizer.localized("btn_reservation_disabled")
        giftButtonText = localizer.localized("btn_to_gift")
        reserveButtonText = localizer.localized("btn_to_reserve")
    }
    
    // MARK: - Public Methods
    
    func setBookableState(_ flag:Bool) {
        bookableState.accept(flag)
    }
}
