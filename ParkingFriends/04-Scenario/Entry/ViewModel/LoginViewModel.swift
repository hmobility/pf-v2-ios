//
//  LoginViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxLocalizer
import RxSwift
import RxViewController

protocol LoginViewModelType {
    var accountInputText: Observable<String> { get }
    /*
    var passwordInputText: Observable<String> { get }
    var loginText: Observable<String> { get }
    var changeCellNumberText: Observable<String> { get }
    var findPaswordText: Observable<String> { get }
 */
}

class LoginViewModel: LoginViewModelType {
    var accountInputText: Observable<String>
    /*
    var passwordInputText: Observable<String>
    var loginText: Observable<String>
    var changeCellNumberText: Observable<String>
    var findPaswordText: Observable<String>
    */
    init(localizer: LocalizerType = Localizer.shared) {
        accountInputText = Observable.just(localizer.localized("login"))

    }
}
