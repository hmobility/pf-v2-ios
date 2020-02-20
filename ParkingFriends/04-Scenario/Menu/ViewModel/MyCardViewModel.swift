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
}
