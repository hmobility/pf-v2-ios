//
//  SettingsViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol SettingsViewModelType {
    var viewTitle: Driver<String> { get }
    
    var pushSectionTitle: Driver<String> { get }
    var pushFieldText: Driver<String> { get }
    var pushOnOff: BehaviorRelay<Bool> { get }
    var pushDescText: Driver<String> { get }
    
    var pushInGoingFieldText: Driver<String> { get }
    var pushInGoingTimeInterval: Driver<String> { get }
    
    var pushOutGoingFieldText: Driver<String> { get }
    var pushOutGoingTimeInterval: Driver<String> { get }
    
    var voiceRecognitionSectionTitle: Driver<String> { get }
    var voiceRecognitionFieldText: Driver<String> { get }
    var voiceRecognitionOnOff: BehaviorRelay<Bool> { get }
    var voiceRecognitionDescText: Driver<String> { get }
    
    var termsAndPoliciesSectionTitle: Driver<String> { get }
    var usageFieldText: Driver<String> { get }
    var personalInfoFieldText: Driver<String> { get }
    var locationServiceFieldText: Driver<String> { get }
    
    var appInfoSectionTitle: Driver<String> { get }
    var appVersionFieldText: Driver<String> { get }
    var appDisplayVersionText: Driver<String> { get }
    
    var exitSectionTitle: Driver<String> { get }
    var logoutFieldText: Driver<String> { get }
    var withdrawFieldText: Driver<String> { get }
    
    var creditText: Driver<String> { get }
    
    func logoutMessage() -> (title:String, message:String, done:String, cancel:String)
}

class SettingsViewModel: SettingsViewModelType {
    var viewTitle: Driver<String>
    
    var pushSectionTitle: Driver<String>
    var pushFieldText: Driver<String>
    var pushOnOff: BehaviorRelay<Bool> = BehaviorRelay(value:false)
    var pushDescText: Driver<String>
    
    var pushInGoingFieldText: Driver<String>
    var pushInGoingTimeInterval: Driver<String>
    
    var pushOutGoingFieldText: Driver<String>
    var pushOutGoingTimeInterval: Driver<String>
    
    var voiceRecognitionSectionTitle: Driver<String>
    var voiceRecognitionFieldText: Driver<String>
    var voiceRecognitionOnOff: BehaviorRelay<Bool> = BehaviorRelay(value:false)
    var voiceRecognitionDescText: Driver<String>
    
    var termsAndPoliciesSectionTitle: Driver<String>
    var usageFieldText: Driver<String>
    var personalInfoFieldText: Driver<String>
    var locationServiceFieldText: Driver<String>
    
    var appInfoSectionTitle: Driver<String>
    var appVersionFieldText: Driver<String>
    var appDisplayVersionText: Driver<String>
    
    var exitSectionTitle: Driver<String>
    var logoutFieldText: Driver<String>
    var withdrawFieldText: Driver<String>
    
    var creditText: Driver<String>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitle = localizer.localized("ttl_settings")
        
        pushSectionTitle = localizer.localized("ttl_settings_push")
        pushFieldText = localizer.localized("ttl_settings_push_argreement")
        pushDescText = localizer.localized("dsc_settings_push_agreement")
        
        pushInGoingFieldText = localizer.localized("ttl_settings_ingoing_push")
        pushInGoingTimeInterval = localizer.localized("txt_minutes_before")
        
        pushOutGoingFieldText = localizer.localized("ttl_settings_outgoing_push")
        pushOutGoingTimeInterval = localizer.localized("txt_minutes_before")
        
        voiceRecognitionSectionTitle = localizer.localized("ttl_settings_voice_recognition")
        voiceRecognitionFieldText = localizer.localized("ttl_settings_voice_command")
        voiceRecognitionDescText = localizer.localized("dsc_settings_voice_command")
        
        termsAndPoliciesSectionTitle = localizer.localized("ttl_settings_terms_and_policies")
        usageFieldText = localizer.localized("ttl_settings_use_terms")
        personalInfoFieldText = localizer.localized("ttl_settings_personal_info_terms")
        locationServiceFieldText = localizer.localized("ttl_settings_location_service_terms")
        
        appInfoSectionTitle = localizer.localized("ttl_settings_app_info")
        appVersionFieldText = localizer.localized("ttl_settings_app_version")
        appDisplayVersionText = localizer.localized("txt_settings_app_up_to_date")
        
        exitSectionTitle = localizer.localized("ttl_settings_exit")
        logoutFieldText = localizer.localized("ttl_settings_logout")
        withdrawFieldText = localizer.localized("ttl_settings_withdraw")
        
        creditText = localizer.localized("txt_credit")
    }
    
    //

    func logoutMessage() -> (title:String, message:String, done:String, cancel:String) {
        let title:String = localizer.localized("ttl_pop_logout")
        let message:String = localizer.localized("dsc_pop_logut")
        let done:String = localizer.localized("btn_logout")
        let cancel:String = localizer.localized("btn_cancel")
        
        return (title:title, message:message, done:done, cancel)
    }
    

    // MARK: - Public Methods
    
}

