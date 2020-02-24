//
//  MyCardViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol MyCardViewModelType {
    var viewTitle: Driver<String> { get }
    var cardCountText: Driver<String> { get }
    
    func loadCreditCard()
    func getCardItems() -> Observable<[CardElement]>
    func setDefaultCreditCard(with cardId:Int)
    func deleteCreditCard(with cardId:Int)
    
    func getAlertRemoveMessage() -> AlertTextType
    func getAlertDefaultMessage() -> AlertTextType
}

class MyCardViewModel: MyCardViewModelType {
    var viewTitle: Driver<String>
    var cardCountText: Driver<String>
    
    var cardItems:BehaviorRelay<[CardElement]?> = BehaviorRelay(value:nil)
    
    var localizer:LocalizerType
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        viewTitle = localizer.localized("ttl_my_card")
        cardCountText = localizer.localized("ttl_my_card_count")
    }
    
    // MARK: - Public Methods
    
    public func getCardItems() -> Observable<[CardElement]> {
        return cardItems
            .filter { $0 != nil }
            .map { $0! }
    }
    
    // MARK: - Alert Message
    
    func getAlertRemoveMessage() -> AlertTextType {
        let title:String = localizer.localized("ttl_credit_card_remove")
        let message:String = localizer.localized("dsc_credit_card_remove")
        let done:String = localizer.localized("btn_remove")
        let cancel:String = localizer.localized("btn_cancel")
        
        return (title:title, message:message, done:done, cancel)
    }
    
    func getAlertDefaultMessage() -> AlertTextType {
        let title:String = localizer.localized("ttl_credit_card_set_default")
        let message:String = localizer.localized("dsc_credit_card_set_default")
        let done:String = localizer.localized("btn_apply")
        let cancel:String = localizer.localized("btn_cancel")
        
        return (title:title, message:message, done:done, cancel)
    }
    
    
    // MARK: - Network
    
    public func loadCreditCard() {
        Member.cards()
            .asObservable()
            .filter { (cards, status) in
                cards != nil
            }
            .map { (cards, status) in
                return cards!.elements
            }
            .bind(to: cardItems)
            .disposed(by: disposeBag)
    }
    
    public func setDefaultCreditCard(with cardId:Int) {
        Member.cards(id: cardId)
            .asObservable()
            .map {
                return $0 == .success
            }
            .subscribe(onNext: { [unowned self] success in
                if success {
                    self.loadCreditCard()
                }
            })
            .disposed(by: disposeBag)
    }
    
    public func deleteCreditCard(with cardId:Int) {
        Member.delete_cards(id: cardId)
            .asObservable()
            .map {
                return $0 == .success
            }
            .subscribe(onNext: { [unowned self] success in
                if success {
                    self.loadCreditCard()
                }
            })
            .disposed(by: disposeBag)
    }
}
