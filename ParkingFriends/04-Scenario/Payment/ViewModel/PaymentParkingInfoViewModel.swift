//
//  PaymentParkingInfoViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/30.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentParkingInfoViewModelType {
}

class PaymentParkingInfoViewModel: PaymentParkingInfoViewModelType {
  //  var viewTitleText: Driver<String>

    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
    }
}
