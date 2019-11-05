//
//  AgreementViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxLocalizer
import RxSwift
import RxViewController

protocol AgreementViewModelType {
    var agreementTitle: Observable<String> { get }
    var agreementSubTitle: Observable<String> { get }
}

class AgreementViewModel: AgreementViewModelType {
    var agreementTitle: Observable<String>
    var agreementSubTitle: Observable<String>
    
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        agreementTitle = Observable.just(localizer.localized("phone_number_input_title"))
        agreementSubTitle = Observable.just(localizer.localized("email_input_title"))
    }
    
    public func placeholder(textField:UITextField, _ placeholder:String) {
        textField.placeholder = localizer.localized(placeholder)
    }
}


