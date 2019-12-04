//
//  RegiCarViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol RegiCarViewModelType {
    var viewTitleText: Driver<String> { get }
}

class RegiCarViewModel: RegiCarViewModelType {
    var viewTitleText: Driver<String>
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_car_info_registration")
    }
}
