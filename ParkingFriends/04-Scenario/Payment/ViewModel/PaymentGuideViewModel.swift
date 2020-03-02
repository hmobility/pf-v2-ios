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
    
    var displayState: BehaviorRelay<Bool> { get }
}

class PaymentGuideViewModel: PaymentGuideViewModelType {
    var viewTitleText: Driver<String>
    var contentsText: Driver<String>
    var closeText: Driver<String>
    var agreementText: Driver<String>
    var noDisplayText: Driver<String>
    
    var displayState: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    var localizer:LocalizerType
    var userData:UserData
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, userData: UserData = UserData.shared) {
        self.localizer = localizer
        self.userData = userData
        
        viewTitleText = localizer.localized("ttl_payment_guide")
        contentsText = localizer.localized("txt_payment_contents")
        closeText = localizer.localized("btn_close")
        agreementText = localizer.localized("btn_to_agree")
        noDisplayText = localizer.localized("txt_payment_guide_no_display")
        
        setupBinding()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        displayState.asObservable()
            .subscribe(onNext: { checked in
                self.userData.displayPaymentGuide = checked
            })
            .disposed(by: disposeBag)
    }
}
