//
//  MyCardAddingViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol MyCardAddingViewModelType {
    var viewTitle: Driver<String> { get }
    var cardAddingDescText: Driver<String> { get }
    var confirmText: Driver<String> { get }
    
    var cardNumberInputTitle: Driver<String> { get }
    var cardNumberInputPlaceholder: Driver<String> { get }
    var cardNumberMessageText: BehaviorRelay<String> { get set }
    
    var expirationDateInputTitle: Driver<String> { get }
    var expirationDateInputPlaceholder: Driver<String> { get }
    var expirationDateMessageText: BehaviorRelay<String> { get set }
    
    var passwordTwoDigitsInputTitle: Driver<String> { get }
    var passwordTwoDigitsInputPlaceholder: Driver<String> { get }
    var passwordTwoDigitsMessageText: BehaviorRelay<String> { get set }
    
    var residentNumberInputTitle: Driver<String> { get }
    var residentNumberInputPlaceholder: Driver<String> { get }
    var residentNumberMessageText: BehaviorRelay<String> { get set }
    
    var holderNameInputTitle: Driver<String> { get }
    var holderNameInputPlaceholder: Driver<String> { get }
    var holderNameMessageText: BehaviorRelay<String> { get set }
    
    var proceed: BehaviorRelay<(ProceedType, String)> { get }
    
    func validateCredentials(section:CreditCardSectionType, editing:Bool) -> Bool
    func accept(_ text:String, section:CreditCardSectionType)
    
    func formatted(section:CreditCardSectionType, textField:UITextField, range:NSRange, replacement:String)
    
    func requestRegisterCard()
}


class MyCardAddingViewModel: MyCardAddingViewModelType {
    var viewTitle: Driver<String>
    var cardAddingDescText: Driver<String>
    var confirmText: Driver<String>
    
    var cardNumberInputTitle: Driver<String>
    var cardNumberInputPlaceholder: Driver<String>
    var cardNumberMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var expirationDateInputTitle: Driver<String>
    var expirationDateInputPlaceholder: Driver<String>
    var expirationDateMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var passwordTwoDigitsInputTitle: Driver<String>
    var passwordTwoDigitsInputPlaceholder: Driver<String>
    var passwordTwoDigitsMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var residentNumberInputTitle: Driver<String>
    var residentNumberInputPlaceholder: Driver<String>
    var residentNumberMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var holderNameInputTitle: Driver<String>
    var holderNameInputPlaceholder: Driver<String>
    var holderNameMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var validate: BehaviorRelay<Bool> = BehaviorRelay(value:false)
    var proceed: BehaviorRelay<(ProceedType, String)> = BehaviorRelay(value:(.none, ""))
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    private var creditCardModel: CreditCardModelType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, creditCard:CreditCardModelType = CreditCardModel()) {
        self.localizer = localizer
        self.creditCardModel = creditCard
        
        viewTitle = localizer.localized("ttl_my_card_add")
        cardAddingDescText = localizer.localized("dsc_my_card_add")
        
        cardNumberInputTitle = localizer.localized("ttl_input_card_number")
        cardNumberInputPlaceholder = localizer.localized("ph_input_card_number")
        
        expirationDateInputTitle = localizer.localized("ttl_input_input_card_expiration_date")
        expirationDateInputPlaceholder = localizer.localized("ph_input_card_expiration_date")
        
        passwordTwoDigitsInputTitle = localizer.localized("ttl_input_card_password")
        passwordTwoDigitsInputPlaceholder = localizer.localized("ph_input_card_password")
        
        residentNumberInputTitle = localizer.localized("ttl_input_resident_number")
        residentNumberInputPlaceholder = localizer.localized("ph_input_resident_number")
        
        holderNameInputTitle = localizer.localized("ttl_input_card_owner_name")
        holderNameInputPlaceholder = localizer.localized("ph_input_card_owner_name")
        
        confirmText = localizer.localized("btn_to_save")
    }
    
    // MARK: - Local Methods
    
    // 입력창 별 체크
    func updateStatus(section:CreditCardSectionType, editing:Bool = false) -> Bool {
        let result = creditCardModel.validate(type: section)
        let checkMessage = !editing || (result.check == .valid)
        
        if checkMessage {
            switch section {
            case .number:
                cardNumberMessageText.accept(result.message)
            case .expiration_date:
                expirationDateMessageText.accept(result.message)
            case .password:
                passwordTwoDigitsMessageText.accept(result.message)
            case .resident_number:
                residentNumberMessageText.accept(result.message)
            case .holder_name:
                holderNameMessageText.accept(result.message)
            }
        }
        
        return (result.check == .valid)
    }
    
    // 다음 프로세스 진행 체크
    func updateProcess(_ type:ProceedType) {
        switch type {
        case .none, .disabled:
             proceed.accept((type, ""))
        case .enabled:
            proceed.accept((.enabled, ""))
        case .success:
            proceed.accept((.success, ""))
        case .failure:
            let message = localizer.localized("msg_credit_card_invalid") as String
            proceed.accept((.failure, message))
        }
    }
    
    // MARK: - Public Methods
    
    func accept(_ text:String, section:CreditCardSectionType) {
        switch section {
        case .number:
            _ = creditCardModel.accept(text, type:.number)
        case .expiration_date:
            _ = creditCardModel.accept(text, type:.expiration_date)
        case .password:
            _ = creditCardModel.accept(text, type:.password)
        case .resident_number:
            _ = creditCardModel.accept(text, type:.resident_number)
        case .holder_name:
            _ = creditCardModel.accept(text, type:.holder_name)
        }
    }
    
    func formatted(section:CreditCardSectionType, textField:UITextField, range:NSRange, replacement:String) {
        switch section {
        case .number:
            _ = creditCardModel.formatted(section:.number, textField:textField, range:range, replacement:replacement)
        case .expiration_date:
            _ = creditCardModel.formatted(section:.expiration_date, textField:textField, range:range, replacement:replacement)
        default:
            break
        }
        
        _ = self.validateCredentials(section:section, editing:true)
    }
    
    func validateCredentials(section:CreditCardSectionType, editing:Bool = false) -> Bool {
        let sections = CreditCardSectionType.allSections.filter { $0 != section }
        var result = false
        
        if updateStatus(section: section, editing:editing) == true {
            for sectionType in sections {
                result = updateStatus(section: sectionType)
                
                if result == false {
                    break
                }
            }
        }
        
        updateProcess(result ? .enabled : .disabled)

        return result
    }

      
    // MARK: - Network
    
    func requestRegisterCard() {
        let cardInfo = self.creditCardModel.creditCard
        
        Member.cards(cardNo: cardInfo.number, yearExpired: cardInfo.expirationYear, monthExpired: cardInfo.expirationMonth, password: cardInfo.password, birthDate: cardInfo.residentNumber, realName:cardInfo.holder)
            .subscribe(onNext: { code in
                if code == .success {
                    self.updateProcess(.success)
                } else {
                    self.updateProcess(.failure)
                }
            })
            .disposed(by: disposeBag)
    }
}
