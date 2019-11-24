//
//  GuideContentViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol GuideContentViewModelType {
    var titleText: Driver<String> { get }
    var subtitleText: Driver<String> { get }
    var pageNumber: BehaviorRelay<Int> { get }
    var guideImage: BehaviorRelay<UIImage> { get }
}

class GuideContentViewModel: GuideContentViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    let pageNumber: BehaviorRelay<Int>
    let guideImage: BehaviorRelay<UIImage>
    
    init(_ index: Int = 0, localizer: LocalizerType = Localizer.shared) {
        let number = index + 1
        pageNumber = BehaviorRelay(value: index)
        guideImage = BehaviorRelay(value: UIImage(named: "imgGuide\(number)")!)
        titleText = localizer.localized("ttl_guide_\(number)")
        subtitleText = localizer.localized("dsc_guide_\(number)")
    }
}
