//
//  MenuViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

protocol MenuViewModelType {
}

class MenuViewModel: MenuViewModelType {
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
}
