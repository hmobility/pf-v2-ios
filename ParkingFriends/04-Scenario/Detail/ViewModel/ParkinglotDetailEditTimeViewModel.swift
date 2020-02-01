//
//  ParkinglotDetailEditTimeViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/29.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailEditTimeViewModelType {
    var viewTitleText: Driver<String> { get }
    var changeButtonTitleText: Driver<String> { get }
    var startDateFieldText: Driver<String> { get }
    var startTimeFieldText: Driver<String> { get }
    var endDateFieldText: Driver<String> { get }
    var endTimeFieldText: Driver<String> { get }
    var closeText: Driver<String> { get }
    var applyText: Driver<String> { get }
}

class ParkinglotDetailEditTimeViewModel: ParkinglotDetailEditTimeViewModelType {
    var viewTitleText: Driver<String>
    var changeButtonTitleText: Driver<String>
    var startDateFieldText: Driver<String>
    var startTimeFieldText: Driver<String>
    var endDateFieldText: Driver<String>
    var endTimeFieldText: Driver<String>
    var closeText: Driver<String>
    var applyText: Driver<String>
    
    private var localizer:LocalizerType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_detail_reserve_time_change")
        changeButtonTitleText = localizer.localized("txt_detail_reserve_time_change")
        startDateFieldText = localizer.localized("ttl_detail_start_date")
        startTimeFieldText = localizer.localized("ttl_detail_start_time")
        endDateFieldText = localizer.localized("ttl_detail_end_date")
        endTimeFieldText = localizer.localized("ttl_detail_end_time")
        closeText = localizer.localized("btn_close")
        applyText = localizer.localized("btn_to_apply")
    }
}
