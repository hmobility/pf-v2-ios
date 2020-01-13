//
//  TimeLabelGuideViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/09.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol CommonLabelGuideViewModelType {
    var rserveLabelTitle: Driver<String> { get }
    var existingTimeText: Driver<String> { get }
    var availableTimeText: Driver<String> { get }
    var unavailableTimeText: Driver<String> { get }
    var unavailableTimeDescText: Driver<String> { get }
    
    var monthlyLabelTitle: Driver<String> { get }
    var existingDayText: Driver<String> { get }
    var availableDayText: Driver<String> { get }
}

class CommonLabelGuideViewModel: CommonLabelGuideViewModelType {
    var rserveLabelTitle: Driver<String>
    var existingTimeText: Driver<String>
    var availableTimeText: Driver<String>
    var unavailableTimeText: Driver<String>
    var unavailableTimeDescText: Driver<String>
    
    var monthlyLabelTitle: Driver<String>
    var existingDayText: Driver<String>
    var availableDayText: Driver<String>

    private var localizer:LocalizerType
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        rserveLabelTitle = localizer.localized("ttl_reserve_label")
        existingTimeText = localizer.localized("txt_guide_existing_time")
        availableTimeText = localizer.localized("txt_guide_available_time")
        unavailableTimeText = localizer.localized("txt_guide_unavailable_time")
        unavailableTimeDescText = localizer.localized("dsc_guide_unavailable_time")
        
        monthlyLabelTitle = localizer.localized("ttl_monthly_label")
        existingDayText = localizer.localized("txt_guide_available_day")
        availableDayText = localizer.localized("txt_guide_unavailable_day")
    }
    
}
