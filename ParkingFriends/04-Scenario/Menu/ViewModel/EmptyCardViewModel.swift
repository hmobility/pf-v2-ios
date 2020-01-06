//
//  NoCardViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


protocol EmptyCardViewModelType {
    var noDataTitle: Driver<String> { get }
    var noDataDescription: Driver<String> { get }
}

class EmptyCardViewModel: EmptyCardViewModelType {
    var noDataTitle: Driver<String>
    var noDataDescription: Driver<String>
    
    private var localizer:LocalizerType
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        noDataTitle = localizer.localized("ttl_no_my_card")
        noDataDescription = localizer.localized("dsc_no_my_card")
    }
    
}
