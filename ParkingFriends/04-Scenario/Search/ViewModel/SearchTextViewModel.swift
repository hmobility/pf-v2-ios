//
//  SearchTextViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

// For Empty, No Result and Guide View

protocol SearchTextViewModelType {
    var searchGuideText: Driver<String> { get }
    var searchGuideDescText: Driver<String> { get }
    var searchNoResultText: Driver<String> { get }
    var searchNoResultDescText: Driver<String> { get }
}

class SearchTextViewModel: SearchTextViewModelType {
    var searchGuideText: Driver<String>
    var searchGuideDescText: Driver<String>
    var searchNoResultText: Driver<String>
    var searchNoResultDescText: Driver<String>
    
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer

        searchGuideText = localizer.localized("ttl_search_guide_parkinglot")
        searchGuideDescText = localizer.localized("dsc_search_guide_parkinglot")
        searchNoResultText = localizer.localized("ttl_search_no_result")
        searchNoResultDescText = localizer.localized("dsc_search_no_result")
    }
}
