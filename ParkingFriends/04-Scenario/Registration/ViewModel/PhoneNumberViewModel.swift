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
    var credential: BehaviorRelay<(CheckType, String?)> { get }
    
    var proceed: BehaviorRelay<Bool> { get }
    var registrationMdoel : RegistrationModel { get }
    
    func validateCredentials()
    func updateStatus(_ status:CheckType)
    func message(_ status:CheckType) -> String
}

class PhoneNumberViewModel: PhoneNumberViewModelType {
    let titleText: Driver<String>
    let subtitleText: Driver<String>
    
    let inputTitle: Driver<String>
    let inputPlaceholder: Driver<String>
    
    let sendText: Driver<String>
    
    let phoneNumberModel:PhoneNumberModel = PhoneNumberModel()
    
    var status:BehaviorRelay<VerificationStatus> = BehaviorRelay(value:.none)
    
    let credential: BehaviorRelay<(CheckType, String?)> = BehaviorRelay(value: (.none, nil))
    var proceed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var registrationMdoel: RegistrationModel = RegistrationModel.shared
     
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
     
    // MARK: - Initialize
     
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        titleText = localizer.localized("ttl_phone_number_verify")
        subtitleText = localizer.localized("dsc_pnone_number_verify")
            
        inputTitle = localizer.localized("ttl_input_phone_number")
        inputPlaceholder = localizer.localized("ph_input_phone_number")
        
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
    }
    
    // MARK: - Public Methods
    
    func updateStatus(_ status:CheckType) {
        switch status {
        case .valid:
            proceed.accept(true)
            credential.accept((status, nil))
        case .sent:
            proceed.accept(true)
            credential.accept((status, localizer.localized("msg_code_verify_sent")))
        case .invalid:
            proceed.accept(false)
            credential.accept((status, localizer.localized("msg_email_invalid")))
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
            rquestOtp(phoneNumber: number)
        }
    }
    
    func message(_ status:CheckType) -> String {
        switch status {
        case .sent:
            return localizer.localized("msg_code_verify_sent")
        case .invalid:
            return localizer.localized("msg_phone_number_invalid")
        default :
            return ""
        }
    }
    
    // MARK : Local Methods
    
    func rquestOtp(phoneNumber:String) {
        Auth.otp(phoneNumber: phoneNumber).asObservable().subscribe(onNext: {(otp, code) in
            if code == .success {
                self.registrationMdoel.otp(otp!, phoneNumber: phoneNumber)
                self.updateStatus(.sent)
            } else {
                self.registrationMdoel.resetOtp()
                self.updateStatus(.invalid)
            }
        }, onError: { error in
            self.registrationMdoel.resetOtp()
            self.updateStatus(.invalid)
        }).disposed(by: disposeBag)
    }
}
