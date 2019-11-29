//
//  PhoneNumberViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/20.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import AnyFormatKit

protocol CodeVerifyViewModelType {
    var titleText: Driver<String> { get }
    var subtitleText: Driver<String> { get }
    
    var inputTitle: Driver<String> { get }
    var inputPlaceholder: Driver<String> { get }
    var countdownText: BehaviorRelay<String> { get }
    var codeText: BehaviorRelay<String> { get }
    
    var nextText: Driver<String> { get }
 
    var proceed: BehaviorRelay<(CheckType, String?)> { get }
    
    var registrationMdoel : RegistrationModel { get }
    
    func startTimer()
    func stopTimer()
    func requestOtp(phoneNumber:String)
    func checkOtp(phoneNumber:String, otp:String, otpId:Int)
}

fileprivate let timer_count = 180 // seconds

public let codeVerifyFormatter = DefaultTextInputFormatter(textPattern:  "####")

class CodeVerifyViewModel: CodeVerifyViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    
    let inputTitle: Driver<String>
    let inputPlaceholder: Driver<String>
    let countdownText: BehaviorRelay<String>
    let codeText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let nextText: Driver<String>
    
    var proceed: BehaviorRelay<(CheckType, String?)> = BehaviorRelay(value: (.none, nil))

    var registrationMdoel: RegistrationModel = RegistrationModel.shared
        
    private var disposeBag = DisposeBag()
    private var localizer:LocalizerType
     
    // MARK: - Initialize
     
    init(localizer: LocalizerType = Localizer.shared, numberFormat: DefaultTextInputFormatter = phoneFormatter, userPhoneNumber:String) {
        self.localizer = localizer
        
        let phoneNumber = numberFormat.format(userPhoneNumber)

        titleText = localizer.localized("ttl_code_verify")
        subtitleText = localizer.localized("dsc_code_verify", arguments: phoneNumber!)
            
        inputTitle = localizer.localized("ttl_input_code_verify")
        inputPlaceholder = localizer.localized("ph_input_code_verify")
        countdownText = BehaviorRelay(value: String().stringFromSecondsInterval(seconds: timer_count))
        
        nextText = localizer.localized("btn_to_next")
        
        initialize()
    }
    
    private func initialize() {
        setupBidning()
    }
    
    // MARK: - Bindings
    
    private func setupBidning() {
        _ = codeText.subscribe(onNext: { text in
            print("[D]", text)
            let status:CheckType = text.count < 4 ? .none : .valid
            self.updateStatus(status)
        })
     }
     
    // MARK: - Public Methods
    
    func startTimer() {
        disposeBag = DisposeBag()

        Observable<Int>.interval(.seconds(1), scheduler: ConcurrentMainScheduler.instance)
            .map({ seconds in
                timer_count - seconds
            })
            .takeWhile({ seconds in
                seconds >= 0
            })
            .map { seconds in
                (String().stringFromSecondsInterval(seconds:seconds), seconds)
            }
            .subscribe(onNext: { (seconds, origin) in
                debugPrint("[SEC] ", seconds, " [CODE] ", self.codeText.value)
                self.countdownText.accept(seconds)
                
                if origin == 0 {
                    self.codeText.accept("")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func stopTimer() {
        disposeBag = DisposeBag()
    }
    
    // MARK : Local Methods
    
    func updateStatus(_ status:CheckType) {
        switch status {
        case .valid:
            proceed.accept((status, nil))
        case .sent:
            let message = self.localizer.localized("msg_code_verify_sent") as String
            proceed.accept((status, message))
        case .invalid:
            let message = self.localizer.localized("msg_code_verify_invalid") as String
            proceed.accept((status, message))
        case .verified:
           // let message = self.localizer.localized("msg_code_verify_valid") as String
            proceed.accept((status, nil))
        default:
            proceed.accept((status, nil))
        }
    }
    
    func requestOtp(phoneNumber:String) {
        Auth.otp(phoneNumber: phoneNumber).asObservable().subscribe(onNext: {(otp, code) in
            if code == .success {
                self.registrationMdoel.otp(otp!, phoneNumber: phoneNumber)
                self.codeText.accept("")
                self.updateStatus(.sent)
                self.startTimer()
            } else {
                self.registrationMdoel.resetOtp()
                self.updateStatus(.invalid)
            }
        }, onError: { error in
            self.registrationMdoel.resetOtp()
            self.updateStatus(.invalid)
        }).disposed(by: disposeBag)
    }
    
    func checkOtp(phoneNumber:String, otp:String, otpId:Int) {
        Auth.otp_check(phoneNumber: phoneNumber, otp: otp, otpId: otpId)
            .subscribe(onNext: { code in
                if code == .success {
                    print("[CODE] verified!!!!!")
                    self.updateStatus(.verified)
                    self.stopTimer()
                } else {
                    self.registrationMdoel.resetOtp()
                    self.updateStatus(.invalid)
                }
            })
            .disposed(by: disposeBag)
    }
}
