//
//  AgreementViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol AgreementViewModelType {
    var agreementTitle: Driver<String> { get }
    var agreementSubTitle: Driver<String> { get }
    
    var usageText: Driver<String> { get }
    var personalInfoText: Driver<String> { get }
    var locationServiceText: Driver<String> { get }
    var thirdPartyText: Driver<String> { get }
    var marketingInfoText: Driver<String> { get }
    
    var sentenceText: Driver<String> { get }
    var agreeAllText: Driver<String> { get }
    var agreementOptionText: Driver<String> { get }
    
    var proceed: BehaviorRelay<(ProceedType, String)> { get }

    func setCheckAllState(_ checkedAll:Bool)
    func setAgreeWithThirdParty(check flag:Bool)
    func requestSignup()
}

class AgreementViewModel: AgreementViewModelType {

    var agreementTitle: Driver<String>
    var agreementSubTitle: Driver<String>
    
    var usageText: Driver<String>
    var personalInfoText: Driver<String>
    var locationServiceText: Driver<String>
    var thirdPartyText: Driver<String>
    var marketingInfoText: Driver<String>
    
    var agreementOptionText: Driver<String>
    var sentenceText: Driver<String>
    var agreeAllText: Driver<String>
    
    var proceed: BehaviorRelay<(ProceedType, String)> = BehaviorRelay(value:(.none, ""))
    
    private var localizer:LocalizerType
    private var registrationMdoel: RegistrationModel
    
    private var disposeBag = DisposeBag()

    init(localizer: LocalizerType = Localizer.shared, registration:RegistrationModel) {
        self.localizer = localizer
        self.registrationMdoel = registration
        
        agreementTitle = localizer.localized("ttl_agreement")
        agreementSubTitle = localizer.localized("dsc_agreement")
        
        usageText = localizer.localized("ttl_usage")
        personalInfoText = localizer.localized("ttl_personal_info")
        locationServiceText = localizer.localized("ttl_location_service")
        thirdPartyText = localizer.localized("ttl_third_party_info")
        marketingInfoText = localizer.localized("ttl_marketing_info")
        
        sentenceText = localizer.localized("txt_agreement_sentence_end")
        agreeAllText = localizer.localized("txt_agree_all")
        agreementOptionText = localizer.localized("txt_agreement_option")
    }
    
    // MARK: - Public Methods
    
    func setCheckAllState(_ checkedAll:Bool) {        
        updateProcess(checkedAll ? .enabled : .disabled)
    }
    
    func updateProcess(_ type:ProceedType) {
        switch type {
        case .none, .disabled:
            proceed.accept((type, ""))
        case .enabled:
            proceed.accept((.enabled, ""))
        case .success:
            proceed.accept((.success, ""))
        case .failure:
            let message = localizer.localized("msg_network_error") as String
            proceed.accept((.failure, message))
        }
    }
    
    func setAgreeWithThirdParty(check flag:Bool) {
        self.registrationMdoel.isThirdPartyAgreement = flag
    }
    
    // MARK: - Network
    
    func requestSignup() {
        let username = registrationMdoel.phoneNumber!
        let password = registrationMdoel.password!
        let email = registrationMdoel.email!
        let nickname = registrationMdoel.nickname!
        let oldMemberId:Int = registrationMdoel.checkOldMember == nil ? 0 : registrationMdoel.checkOldMember!.id
        let isMarketingAgreement = registrationMdoel.isThirdPartyAgreement
  
        Member.members(username:username, password:password, email:email, nickname:nickname, oldMemberId:oldMemberId, agreeMarketing:isMarketingAgreement)
            .subscribe(onNext: { (login, code) in
                if code == .success {
                    _ = UserData.shared.setAuth(login)
                    self.updateProcess(.success)
                } else {
                    self.updateProcess(.failure)
                }
            }, onError: { error in
            
            })
            .disposed(by: disposeBag)
    }
}
