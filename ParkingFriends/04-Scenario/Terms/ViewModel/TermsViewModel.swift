//
//  AgreementContentViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol TermsViewModelType {
    var termsTitle: Observable<String> { get }
    
    func update(terms termsType:TermsType)
}

class TermsViewModel: TermsViewModelType {
    
    var termsTitle: Observable<String>
    
    private var termsType: TermsType = .none
   
    private var localizer:LocalizerType
    
    init(type: TermsType, localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        termsTitle = Observable.just(TermsViewModel.getTermsTtitle(type))
        //let title = TermsViewModel.getTermsTtitle(termsType)
    }
    
    public func update(terms termsType:TermsType = .none) {
        self.termsType = termsType
        let title = TermsViewModel.getTermsTtitle(termsType)
        termsTitle = Observable.just(title)
    }
    
    private class func getTermsTtitle(_ type:TermsType, localizer: LocalizerType = Localizer.shared) -> String {
        switch type {
        case .usage:
            return localizer.localized("usage_title")
        case .personal_info:
            return localizer.localized("personal_info_title")
        case .location_service:
            return localizer.localized("location_service_title")
        case .marketing_info:
            return localizer.localized("marketing_info_title")
        case .third_party_info:
            return localizer.localized("third_party_info_title")
        default:
            return localizer.localized("")
        }
    }
}

