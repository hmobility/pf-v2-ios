//
//  CarBrandViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/06.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

protocol CarBrandViewModelType {
    var viewTitleText: Driver<String> { get }
}

class CarBrandViewModel: CarBrandViewModelType {
    var viewTitleText: Driver<String>
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_car_info_registration")
        
    }
}

