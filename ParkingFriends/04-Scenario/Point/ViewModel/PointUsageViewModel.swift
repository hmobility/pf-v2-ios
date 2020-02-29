//
//  PointUsageViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


protocol PointUsageViewModelType {
    var viewTitleText: Driver<String> { get }
    
}

class PointUsageViewModel: PointUsageViewModelType {
    var viewTitleText: Driver<String>

    
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_point_usage")
          
    }
}
