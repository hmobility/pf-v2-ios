//
//  MyCardViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol MyCardViewModelType {
    var viewTitle: Driver<String> { get }
    var cardCountText: Driver<String> { get }
}

class MyCardViewModel: MyCardViewModelType {
    var viewTitle: Driver<String>
    var cardCountText: Driver<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        viewTitle = localizer.localized("ttl_my_card")
        cardCountText = localizer.localized("ttl_my_card_count")
    }
}
