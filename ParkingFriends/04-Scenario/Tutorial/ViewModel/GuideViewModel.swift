//
//  GuideViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxLocalizer
import RxSwift
import RxViewController

protocol GuideViewModelType {
    var skipText: Observable<String> { get }
    var nextText: Observable<String> { get }
}

class GuideViewModel: GuideViewModelType {
    var skipText: Observable<String>
    var nextText: Observable<String>
    
    init(localizer: LocalizerType = Localizer.shared) {
        skipText = Observable.just(localizer.localized("guide_skip"))
        nextText = Observable.just(localizer.localized("guide_next"))
    }
}
