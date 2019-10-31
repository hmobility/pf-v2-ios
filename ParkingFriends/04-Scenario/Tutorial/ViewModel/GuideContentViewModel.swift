//
//  GuideContentViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxLocalizer
import RxSwift
import RxViewController

protocol GuideContentViewModelType {
    var titleText: Observable<String> { get }
    var subtitleText: Observable<String> { get }
    var pageNumber: Observable<Int> { get }
    var guideImage: Observable<UIImage> { get }
}

class GuideContentViewModel: GuideContentViewModelType {
    let titleText: Observable<String>
    let subtitleText: Observable<String>
    let pageNumber: Observable<Int>
    let guideImage: Observable<UIImage>
    
    private let disposeBag = DisposeBag()
    
    init(_ index: Int = 0, localizer: LocalizerType = Localizer.shared) {
        let number = index + 1
        pageNumber = Observable.just(index)
        guideImage = Observable.just(UIImage(named: "imgGuide\(number)")!)
        titleText = Observable.just(localizer.localized("guide_title_\(number)"))
        subtitleText = Observable.just(localizer.localized("guide_subtitle_\(number)"))
    }
}
