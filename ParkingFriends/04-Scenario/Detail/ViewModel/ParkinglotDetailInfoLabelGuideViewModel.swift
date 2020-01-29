//
//  TimeLabelGuideViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/09.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailInfoLabelGuideViewModelType {
    var timeTicketLabelTitle: Driver<String> { get }
    var existingTimeText: Driver<String> { get }
    var availableTimeText: Driver<String> { get }
    var unavailableTimeText: Driver<String> { get }
    var unavailableTimeDescText: Driver<String> { get }
    
    var fixedTicketLabelTitle: Driver<String> { get }
    var availableDayText: Driver<String> { get }
    var unavailableDayText: Driver<String> { get }
}

class ParkinglotDetailInfoLabelGuideViewModel: ParkinglotDetailInfoLabelGuideViewModelType {
    var timeTicketLabelTitle: Driver<String>
    var existingTimeText: Driver<String>
    var availableTimeText: Driver<String>
    var unavailableTimeText: Driver<String>
    var unavailableTimeDescText: Driver<String>
    
    var fixedTicketLabelTitle: Driver<String>
    var availableDayText: Driver<String>
    var unavailableDayText: Driver<String>
    
    private var localizer:LocalizerType
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        timeTicketLabelTitle = localizer.localized("ttl_reserve_label")
        existingTimeText = localizer.localized("txt_guide_existing_time")
        availableTimeText = localizer.localized("txt_guide_available_time")
        unavailableTimeText = localizer.localized("txt_guide_unavailable_time")
        unavailableTimeDescText = localizer.localized("dsc_guide_unavailable_time")
        
        fixedTicketLabelTitle = localizer.localized("ttl_monthly_label")
        availableDayText = localizer.localized("txt_guide_available_day")
        unavailableDayText = localizer.localized("txt_guide_unavailable_day")
    }
    
}
