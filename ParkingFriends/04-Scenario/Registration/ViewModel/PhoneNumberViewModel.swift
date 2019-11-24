//
//  PhoneNumberViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/20.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PhoneNumberViewModelType {
    var titleText: Driver<String> { get }
    var subtitleText: Driver<String> { get }
    
    var inputTitle: Driver<String> { get }
    var inputPlaceholder: Driver<String> { get }
    
    var sendText: Driver<String> { get }
    
    var phoneNumberModel:PhoneNumberModel { get }
    var status:BehaviorRelay<VerificationStatus> { get set }
    var credential: BehaviorRelay<(SentStatus, String?)> { get }
    
    var proceed: BehaviorRelay<Bool> { get }
    
    func validateCredentials()
    func updateStatus(_ status:SentStatus)
    func message(_ status:SentStatus) -> String
}

class PhoneNumberViewModel: PhoneNumberViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    
    let inputTitle: Driver<String>
    let inputPlaceholder: Driver<String>
    
    let sendText: Driver<String>
    
    let phoneNumberModel:PhoneNumberModel = PhoneNumberModel()
    
    var status:BehaviorRelay<VerificationStatus> = BehaviorRelay(value:.none)
    
    let credential: BehaviorRelay<(SentStatus, String?)> = BehaviorRelay(value: (.none, nil))
    var proceed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
     
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
     
    // MARK: - Initialize
     
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        titleText = localizer.localized("ttl_phone_number_verify")
        subtitleText = localizer.localized("dsc_pnone_number_verify")
            
        inputTitle = localizer.localized("ttl_phone_number_input")
        inputPlaceholder = localizer.localized("ph_phone_number_input")
        
        sendText = localizer.localized("btn_code_send")
        
        initialize()
    }
    
    // MARK: - Local Methods
    
    private func initialize() {
        setupBidning()
    }
    
    private func setupBidning() {
        
        phoneNumberModel.valid
            .asDriver()
            .drive(onNext: { valid in
                self.updateStatus(valid ? .valid : .none )
            })
            .disposed(by: disposeBag)
        /*
        phoneNumberModel.data
            .asDriver()
            .asObservable()
            .scan("") { (previous, new) -> String in
                if new.count > 11 {
                    return previous
                } else {
                    return new
                }
            }
            .subscribe(onNext: { text in
                
                let result = text.validatePattern(type: .phone_number)
                
                print("[R]", result)
               // self.phoneNumberModel.data.accept(text)
                self.updateStatus(result ? .valid : .none)
               // debugPrint("[MATCHING]", result)
               // print("[UPDATED] ", self.credential.value)
            })
            .disposed(by: disposeBag)
  */
    }
    
    // MARK: - Public Methods
    
    func updateStatus(_ status:SentStatus) {
        switch status {
        case .valid:
            proceed.accept(true)
            credential.accept((status, nil))
        case .sent:
            proceed.accept(true)
            credential.accept((status, localizer.localized("msg_email_sent")))
        case .invalid:
            proceed.accept(false)
            credential.accept((status, localizer.localized("msg_invalid_email")))
        default:
            proceed.accept(false)
            credential.accept((status, nil))
        }
    }
       
    func validateCredentials() {
        if phoneNumberModel.validatePattern() {
            updateStatus(.valid)
        } else {
            updateStatus(.none)
            return
        }
        
        if let number = phoneNumberModel.phoneNumber {
            checkCredentials(phoneNumber: number)
        }
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
    
    // MARK : Local Methods
    
    func checkCredentials(phoneNumber:String) {
        Auth.otp(phoneNumber: phoneNumber).asObservable().subscribe(onNext: {(otp, code) in
            if code == .success {
                RegistrationModel.shared.otp = otp
                self.updateStatus(.sent)
            } else {
                RegistrationModel.shared.otp = nil
                self.updateStatus(.invalid)
            }
            /*
            if let result = otp {
                RegistrationModel.shared.otp = result
                self.updateStatus(.sent)
            } else {
                RegistrationModel.shared.otp = nil
                self.updateStatus(.invalid)
            }
             */
        }, onError: { error in
            RegistrationModel.shared.otp = nil
            self.updateStatus(.invalid)
        }).disposed(by: disposeBag)
        
        return
            /*
        Auth.otp(phoneNumber: phoneNumber) { [weak self] (otp, message)  in
            if let result = otp {
                RegistrationModel.shared.otp = result
                self!.updateStatus(.sent)
            } else {
                RegistrationModel.shared.otp = nil
                self!.updateStatus(.invalid)
            }
        }
 */
    }
}
