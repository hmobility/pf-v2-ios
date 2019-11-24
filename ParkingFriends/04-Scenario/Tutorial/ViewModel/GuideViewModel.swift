//
//  GuideViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol GuideViewModelType {
    var skipText: Driver<String> { get }
    var nextText: Driver<String> { get }
}

class GuideViewModel: GuideViewModelType {
    var skipText: Driver<String>
    var nextText: Driver<String>
    
    init(localizer: LocalizerType = Localizer.shared) {
        skipText = localizer.localized("btn_skip")
        nextText = localizer.localized("btn_to_next")
    }
}
