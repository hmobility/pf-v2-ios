//
//  BasicInfoViewModel.swift
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

protocol BasicInfoViewModelType {
    var phoneNumberInputTitle: Observable<String> { get }
    var phoneNumberMessageText: BehaviorSubject<String> { get }
 //   var phoneNumberInputText: PublishSubject<String> { get }
    
    var emailInputTitle: Observable<String> { get }
    var emailMessageText: BehaviorSubject<String> { get }
    
    var passwordInputTitle: Observable<String> { get }
    var passwordMessageText: BehaviorSubject<String> { get }
    
    var nicknameInputTitle: Observable<String> { get }
    var nicknameMessageText: BehaviorSubject<String> { get }

    func placeholder(textField:UITextField, _ placeholder:String)
}

class BasicInfoViewModel: BasicInfoViewModelType {
    var phoneNumberInputTitle: Observable<String>
  //  var phoneNumberInputText: PublishSubject<String>
    var phoneNumberMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var emailInputTitle: Observable<String>
    var emailMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var passwordInputTitle: Observable<String>
    var passwordMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var nicknameInputTitle: Observable<String>
    var nicknameMessageText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        phoneNumberInputTitle = Observable.just(localizer.localized("phone_number_input_title"))
        emailInputTitle = Observable.just(localizer.localized("email_input_title"))
        passwordInputTitle = Observable.just(localizer.localized("password_input_title"))
        nicknameInputTitle = Observable.just(localizer.localized("nickname_input_title"))
    }
    
    public func placeholder(textField:UITextField, _ placeholder:String) {
        textField.placeholder = localizer.localized(placeholder)
    }
}
