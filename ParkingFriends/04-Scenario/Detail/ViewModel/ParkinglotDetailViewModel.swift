//
//  ParkinglotDetailViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/07.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailViewModelType {
    var viewTitleText: Driver<String> { get }
}

class ParkinglotDetailViewModel: ParkinglotDetailViewModelType {
    
    var viewTitleText: Driver<String>

    private var localizer:LocalizerType
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_ticket_time")
    }
    
}

