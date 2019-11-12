//
//  EntryViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol EntryViewModelType {
    var loginText: Observable<String> { get }
    var signupGuideText: Observable<String> { get }
    var signupText: Observable<String> { get }
}

class EntryViewModel: EntryViewModelType {
    var loginText: Observable<String>
    var signupGuideText: Observable<String>
    var signupText: Observable<String>
    
    init(localizer: LocalizerType = Localizer.shared) {
        loginText = Observable.just(localizer.localized("login"))
        signupGuideText = Observable.just(localizer.localized("signup_guide"))
        signupText = Observable.just(localizer.localized("signup"))
    }
}
