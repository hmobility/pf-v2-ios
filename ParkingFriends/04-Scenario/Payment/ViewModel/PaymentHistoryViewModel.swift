//
//  PaymentHistoryViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentHistoryViewModelType {
}

class PaymentHistoryViewModel: PaymentHistoryViewModelType {
  //  var viewTitleText: Driver<String>

    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
    }
}
