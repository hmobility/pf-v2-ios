//
//  ParkinglotTapViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkinglotTapViewModelType {
    var timeTicketText: Driver<String> { get }
    var fixedTicketText: Driver<String> { get }
    var monthlyTicketText: Driver<String> { get }
    var sortOrderText: Driver<String> { get }
    
    var selectedProductType : BehaviorRelay<ProductType> { get set }
    
    func setProductType(_ type:ProductType)
}

class ParkinglotTapViewModel: ParkinglotTapViewModelType {
    
    var timeTicketText: Driver<String>
    var fixedTicketText: Driver<String>
    var monthlyTicketText: Driver<String>
    var sortOrderText: Driver<String>
    
    var selectedProductType: BehaviorRelay<ProductType> = BehaviorRelay(value: .fixed)

    private var localizer:LocalizerType
    private var userData:UserData
      
    private var defaultFilterOption:FilterOption = FilterOption()
    
    // MARK: - Initialize
      
    init(localizer: LocalizerType = Localizer.shared, userData: UserData = UserData.shared) {
        self.localizer = localizer
        self.userData = userData
        
        timeTicketText = localizer.localized("ttl_ticket_time")
        fixedTicketText = localizer.localized("ttl_ticket_fixed")
        monthlyTicketText = localizer.localized("ttl_ticket_monthly")
        sortOrderText = localizer.localized("itm_price_low")
        
        initialize()
    }
    
    func initialize() {
        setupProductBinding()
    }
    
    // MARK: - Binding
    
    private func setupProductBinding() {
        if let option = userData.productOption {
            selectedProductType.accept(option.selectedProductType)
        }
    }
    
    // MARK: - Public Methods
    
    func setProductType(_ type:ProductType) {
        selectedProductType.accept(type)
    }
}
