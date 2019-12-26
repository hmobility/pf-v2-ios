//
//  FindPasswordViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

public protocol FindPasswordViewModelType {
    var titleText: Driver<String> { get }
    var subtitleText: Driver<String> { get }
    
    var inputTitle: Driver<String> { get }
    var inputPlaceholder: Driver<String> { get }
    
    var data: BehaviorRelay<String> { get set }
    
    var confirmText: BehaviorRelay<String> { get }
    
    var credential: BehaviorRelay<CheckType> { get }
    
    func message(_ status:CheckType) -> String
    func updateStatus(_ status:CheckType)
    func sendVerification(email:String, type:AuthEmailType)
}

class FindPasswordViewModel: FindPasswordViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    
    let inputTitle: Driver<String>
    let inputPlaceholder: Driver<String>
    
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var confirmText: BehaviorRelay<String>
    
    let credential: BehaviorRelay<CheckType> = BehaviorRelay(value: .none)
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        titleText = localizer.localized("ttl_password_find")
        subtitleText = localizer.localized("dsc_password_find")
        
        inputTitle = localizer.localized("ttl_input_email_find")
        inputPlaceholder = localizer.localized("ph_input_email_find")
        
        confirmText = BehaviorRelay(value:localizer.localized("btn_email_send"))
    }
    
    func updateStatus(_ status:CheckType) {
        credential.accept(status)
    }
    
    func message(_ status:CheckType) -> String {
        switch status {
        case .sent:
            return localizer.localized("msg_pw_email_sent")
        case .invalid:
            return localizer.localized("msg_invalid_email")
        default :
            return ""
        }
    }
    
    func sendVerification(email:String, type:AuthEmailType) {
        Auth.email(type: type, email: email).asObservable().subscribe(onNext: { response in
                if response == .success {
                    self.updateStatus(.sent)
                } else {
                    self.updateStatus(.invalid)
                }
            }, onError: { error in
            })
            .disposed(by: disposeBag)
    }
}
