//
//  PaymentPointViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentPointViewModelType {
    var viewTitleText: Driver<String> { get }
    var noPointsText: Driver<String> { get }
    var userPointsText: Driver<String> { get }
    var useAllPointsText: Driver<String> { get }
    var placeholderInputPointsText: Driver<String> { get }
    
    var userPoints:BehaviorRelay<Int> { get }
}

class PaymentPointViewModel: PaymentPointViewModelType {
    var viewTitleText: Driver<String>
    var noPointsText: Driver<String>
    var userPointsText: Driver<String>
    var useAllPointsText: Driver<String>
    var placeholderInputPointsText: Driver<String>
    
    var userPoints:BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_payment_point")
        noPointsText =  localizer.localized("txt_payment_no_point")
        userPointsText = localizer.localized("txt_payment_user_points")
        useAllPointsText = localizer.localized("btn_use_all_points")
        
        placeholderInputPointsText = localizer.localized("ph_input_payment_points")
    }
}
