//
//  FindAccountViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

// 이메일, OPT 발송 상태 체크 용 타입
public enum SentStatus {
    case none
    case valid          // 입력 형식 체크
    case sent           // 발신 완료
    case invalid        // 발신 결과 인증 안됨
}

public protocol ChangePhoneNumberViewModelType {
    var titleText: Driver<String> { get }
    var subtitleText: Driver<String> { get }
    
    var inputTitle: Driver<String> { get }
    var inputPlaceholder: Driver<String> { get }
    
    var data: BehaviorRelay<String> { get set }
    
    var confirmText: BehaviorRelay<String> { get set}
    
    var credential: BehaviorRelay<SentStatus> { get }
    
    func message(_ status:SentStatus) -> String
    func switchButton(_ status:SentStatus)
    func updateStatus(_ status:SentStatus)
    func sendVerification(email:String, type:AuthEmailType)
}

class ChangePhoneNumberViewModel: ChangePhoneNumberViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    
    let inputTitle: Driver<String>
    let inputPlaceholder: Driver<String>
    
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var confirmText: BehaviorRelay<String>
    
    let credential: BehaviorRelay<SentStatus> = BehaviorRelay(value: .none)
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        titleText = localizer.localized("ttl_phone_number_change")
        subtitleText = localizer.localized("dsc_phone_number")
        
        inputTitle = localizer.localized("ttl_iunput_email_find")
        inputPlaceholder = localizer.localized("ph_input_mailr")
        
        confirmText =  BehaviorRelay(value: localizer.localized("btn_email_send"))
    }
    
    // MARK: - Public Methods
    
    func updateStatus(_ status:SentStatus) {
        credential.accept(status)
    }
    
    func message(_ status:SentStatus) -> String {
        switch status {
        case .sent:
            return localizer.localized("msg_email_sent")
        case .invalid:
            return localizer.localized("msg_invalid_email")
        default :
            return ""
        }
    }
    
    func switchButton(_ status:SentStatus) {
        switch status {
        case .sent:
            confirmText.accept(localizer.localized("new_number_login"))
        default :
            confirmText.accept(localizer.localized("send_email"))
        }
    }

    func sendVerification(email:String, type:AuthEmailType) {
        Auth.email(type: type, email: email) { (validated, message) in
            self.updateStatus(validated ? .sent : .invalid)
        }
    }
}
