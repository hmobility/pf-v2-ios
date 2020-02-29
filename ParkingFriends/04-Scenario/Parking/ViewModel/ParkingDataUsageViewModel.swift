//
//  ParkingPopupViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkingDataUsageViewModelType {
    var titleText: Driver<String> { get }
    var descText: Driver<String> { get }
    var dismissText: Driver<String> { get }
    var confirmText: Driver<String> { get }
}


class ParkingDataUsageViewModel: ParkingDataUsageViewModelType {
    var titleText: Driver<String>
    var descText: Driver<String>
    var dismissText: Driver<String>
    var confirmText: Driver<String>
    
    var localizer:LocalizerType
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer

        titleText = localizer.localized("ttl_pop_data_usage_warning")
        descText = localizer.localized("dsc_pop_data_usage_warning")
        dismissText = localizer.localized("btn_preview_cancel")
        confirmText = localizer.localized("btn_preview_ok")
    }
    
}
