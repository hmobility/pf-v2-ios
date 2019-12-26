//
//  GuideFinishedViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol GuideFinishedViewModelType {
    var titleText: Driver<String> { get }
    var subtitleText: Driver<String> { get }
    var pageNumber: BehaviorRelay<Int> { get }
    var guideImage: BehaviorRelay<UIImage> { get }
    var beginText: Driver<String> { get }
}

class GuideFinishedViewModel: GuideFinishedViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    let pageNumber: BehaviorRelay<Int>
    let guideImage: BehaviorRelay<UIImage>
    let beginText: Driver<String>
    
    init(_ index: Int = 4, localizer: LocalizerType = Localizer.shared) {
        let number = index + 1
        pageNumber = BehaviorRelay(value: index)
        guideImage = BehaviorRelay(value: UIImage(named: "imgGuide\(number)")!)
        titleText = localizer.localized("ttl_guide_\(number)")
        subtitleText = localizer.localized("dsc_guide_\(number)")
        beginText = localizer.localized("btn_to_start")
    }
}
