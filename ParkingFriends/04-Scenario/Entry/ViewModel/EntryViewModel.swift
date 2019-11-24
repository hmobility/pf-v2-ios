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
    var loginText: Driver<String> { get }
    var signupGuideText: Driver<String> { get }
    var signupText: Driver<String> { get }
}

class EntryViewModel: EntryViewModelType {
    var loginText: Driver<String>
    var signupGuideText: Driver<String>
    var signupText: Driver<String>
    
    init(localizer: LocalizerType = Localizer.shared) {
        loginText = localizer.localized("btn_login")
        //signupGuideText = localizer.localized("signup_guide")
        signupGuideText = localizer.localized("txt_account_migration_guide")
        signupText = localizer.localized("btn_signup")
    }
}
