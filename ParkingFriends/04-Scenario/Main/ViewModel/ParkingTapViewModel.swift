//
//  ParkinglotTapViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingTapViewModelType {
    var timeTicketText: Driver<String> { get }
    var fixedTicketText: Driver<String> { get }
    var monthlyTicketText: Driver<String> { get }
    var sortOrderText: BehaviorRelay<String> { get }
    
    var selectedProductType : BehaviorRelay<ProductType> { get set }
    var selectedSortType : BehaviorRelay<SortType> { get set }
    
    var elements:BehaviorRelay<[WithinElement]> { get }
    
    func setProductType(_ type:ProductType)
    func setSortType(_ type: SortType)
    func setWithinElements(_ elements:[WithinElement])
    func getTags(_ element:WithinElement) -> [String]
}

class ParkingTapViewModel: ParkingTapViewModelType {
    var timeTicketText: Driver<String>
    var fixedTicketText: Driver<String>
    var monthlyTicketText: Driver<String>
    var sortOrderText: BehaviorRelay<String>
    
    var selectedProductType: BehaviorRelay<ProductType> = BehaviorRelay(value: .fixed)
    var selectedSortType : BehaviorRelay<SortType> = BehaviorRelay(value: .price)
    
    var elements: BehaviorRelay<[WithinElement]> = BehaviorRelay(value: [])

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
        
        selectedSortType = BehaviorRelay(value: self.userData.filter.sortType)
        sortOrderText = BehaviorRelay(value: (self.userData.filter.sortType == .price) ? localizer.localized("itm_order_price")
            : localizer.localized("itm_order_distance"))
        
        initialize()
    }
    
    func initialize() {
        setupProductBinding()
    }
    
    // MARK: - Binding
    
    private func setupProductBinding() {
        let productType = userData.getProductType()
        selectedProductType.accept(productType)
    }
    
    // MARK: - Public Methods
    
    func setProductType(_ type: ProductType) {
        selectedProductType.accept(type)
        userData.setProduct(type: type).save()
    }
    
    func setSortType(_ type: SortType) {
        switch type {
        case .price:
            sortOrderText.accept(localizer.localized("itm_order_price"))
        case .distance:
            sortOrderText.accept(localizer.localized("itm_order_distance"))
        }
    }
    
    func getTags(_ element:WithinElement) -> [String] {
        var tags:[String] = []
        
        if element.cctvFlag {
            tags.append(localizer.localized("itm_cctv"))
        }
        
        if element.outsideFlag {
            tags.append(localizer.localized("itm_cctv"))
        }
        
        if element.chargerFlag {
            tags.append(localizer.localized("itm_evc"))
        }
        
        if element.iotSensorFlag {
            tags.append(localizer.localized("itm_iot"))
        }
        
        tags.append((element.outsideFlag) ? localizer.localized("itm_outdoor") : localizer.localized("itm_indoor"))
        
        return tags
    }
    
    func setWithinElements(_ elements:[WithinElement]){
        self.elements.accept(elements)
    }
}
