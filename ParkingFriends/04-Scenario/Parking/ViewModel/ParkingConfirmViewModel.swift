//
//  ParkingConfirmViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/09.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkingConfirmViewModelType {
    var viewTitleText: Driver<String> { get }
    var descriptionText: Driver<String> { get }

    var cancelText: Driver<String> { get }
    var confirmText: Driver<String> { get }
}

class ParkingConfirmViewModel: ParkingConfirmViewModelType {
    var viewTitleText: Driver<String>
    var descriptionText: Driver<String>
    var cancelText: Driver<String>
    var confirmText: Driver<String>
    
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_parking_entrance_confirm")
        descriptionText = localizer.localized("dsc_parking_entrance_confirm")
        
        cancelText = localizer.localized("btn_no")
        confirmText = localizer.localized("btn_yes")
    }
}
