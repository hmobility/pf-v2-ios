//
//  PaymentGuideViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/02.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

protocol PaymentGuideViewModelType {
    var viewTitleText: Driver<String> { get }
    var contentsText: Driver<String> { get }
    var closeText: Driver<String> { get }
    var agreementText: Driver<String> { get }
    var noDisplayText: Driver<String> { get }
    
    var noDisplayState: BehaviorRelay<Bool> { get }
}

class PaymentGuideViewModel: PaymentGuideViewModelType {
    var viewTitleText: Driver<String>
    var contentsText: Driver<String>
    var closeText: Driver<String>
    var agreementText: Driver<String>
    var noDisplayText: Driver<String>
    
    var noDisplayState: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        viewTitleText = localizer.localized("ttl_payment_guide")
        contentsText = localizer.localized("txt_payment_contents")
        closeText = localizer.localized("btn_close")
        agreementText = localizer.localized("btn_to_agree")
        noDisplayText = localizer.localized("txt_payment_guide_no_display")
    }
}
