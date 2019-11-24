//
//  AgreementViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol AgreementViewModelType {
    var agreementTitle: Observable<String> { get }
    var agreementSubTitle: Observable<String> { get }
    
    var usageText: Observable<NSAttributedString> { get }
    var personalInfoText: Observable<NSAttributedString> { get }
    var locationServiceText: Observable<NSAttributedString> { get }
    var thirdPartyText: Observable<NSAttributedString> { get }
    var marketingInfoText: Observable<NSAttributedString> { get }
    
    var sentenceText: Observable<String> { get }
    var agreeAllText: Observable<String> { get }
    var agreementOptionText: Observable<String> { get }
}

class AgreementViewModel: AgreementViewModelType {

    var agreementTitle: Observable<String>
    var agreementSubTitle: Observable<String>
    
    var usageText: Observable<NSAttributedString>
    var personalInfoText: Observable<NSAttributedString>
    var locationServiceText: Observable<NSAttributedString>
    var thirdPartyText: Observable<NSAttributedString>
    var marketingInfoText: Observable<NSAttributedString>
    
    var agreementOptionText: Observable<String>
    var sentenceText: Observable<String>
    var agreeAllText: Observable<String>
    
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        agreementTitle = Observable.just(localizer.localized("ttl_agreement"))
        agreementSubTitle = Observable.just(localizer.localized("dsc_agreement"))
        
        usageText = Observable.just(NSMutableAttributedString(string:localizer.localized("ttl_usage")))
        personalInfoText = Observable.just(NSMutableAttributedString(string:localizer.localized("ttl_personal_info")))
        locationServiceText = Observable.just(NSMutableAttributedString(string:localizer.localized("ttl_location_service")))
        thirdPartyText = Observable.just(NSMutableAttributedString(string:localizer.localized("ttl_third_party_info")))
        marketingInfoText = Observable.just(NSMutableAttributedString(string:localizer.localized("ttl_marketing_info")))
        
        sentenceText = Observable.just(localizer.localized("txt_agreement_sentence_end"))
        agreeAllText = Observable.just(localizer.localized("txt_agree_all"))
        agreementOptionText = Observable.just(localizer.localized("txt_agreement_option"))
    }
}
