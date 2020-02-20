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
    var tapMenuItems: Driver<[ProductItemType]> { get }
    var sortOrderText: BehaviorRelay<String> { get }
    
    var selectedProductType : BehaviorRelay<ProductType> { get set }
    var selectedSortType : BehaviorRelay<SortType> { get set }
    
    var elements:BehaviorRelay<[WithinElement]> { get }
    
    func setProductType(_ type:ProductType)
    func setSelectedProductItem(with index:Int)
    func getSelectedProductItem() -> Observable<(index:Int, type:ProductType, title:String)>
    
    func setSortType(_ type: SortType)
    func setWithinElements(_ elements:[WithinElement]?)
    func getTags(_ element:WithinElement) -> [String]
}

class ParkingTapViewModel: ParkingTapViewModelType {
    var tapMenuItems: Driver<[ProductItemType]>
    var timeTicketText: Driver<String>
    var fixedTicketText: Driver<String>
    var monthlyTicketText: Driver<String>
    var sortOrderText: BehaviorRelay<String>
    
    var selectedProductType: BehaviorRelay<ProductType> = BehaviorRelay(value: .time)
    var selectedSortType : BehaviorRelay<SortType> = BehaviorRelay(value: .price)
    
    var elements: BehaviorRelay<[WithinElement]> = BehaviorRelay(value: [])

    private var localizer:LocalizerType
    private var userData:UserData
      
    private var defaultFilterOption:FilterOption = FilterOption()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initialize
      
    init(localizer: LocalizerType = Localizer.shared, userData: UserData = UserData.shared) {
        self.localizer = localizer
        self.userData = userData
        
        tapMenuItems = Driver.just([(type: .time, title: localizer.localized("ttl_ticket_time") as String),
                        (type: .fixed, title: localizer.localized("ttl_ticket_fixed") as String),
                         (type: .monthly, title: localizer.localized("ttl_ticket_monthly") as String)])
        
        timeTicketText = localizer.localized("ttl_ticket_time")
        fixedTicketText = localizer.localized("ttl_ticket_fixed")
        monthlyTicketText = localizer.localized("ttl_ticket_monthly")
        
        let sortType = self.userData.getSortType()
        selectedSortType = BehaviorRelay(value: sortType)
        sortOrderText = BehaviorRelay(value: (sortType == .price) ? localizer.localized("itm_order_price") : localizer.localized("itm_order_distance"))
        
        initialize()
    }
    
    func initialize() {
        setupProductBinding()
    }
    
    // MARK: - Binding
    
    private func setupProductBinding() {
        let productType = userData.productSettings.getProductType()
        selectedProductType.accept(productType)
    }
    
    // MARK: - Public Methods
    
    func setProductType(_ type: ProductType) {
        selectedProductType.accept(type)
        userData.productSettings.setProduct(type: type).save()
    }
    
    func setSelectedProductItem(with index:Int) {
        tapMenuItems.asObservable()
            .map { return $0[index] }
            .asObservable()
            .subscribe(onNext: { [unowned self] item in
                self.setProductType(item.type)
            })
            .disposed(by: disposeBag)
    }
    
    func getSelectedProductItem() -> Observable<(index:Int, type:ProductType, title:String)> {
        return tapMenuItems.asObservable()
            .map { items in
                return items.enumerated().compactMap { item -> (Int, ProductType, String)? in
                    if item.element.type == self.selectedProductType.value {
                        return (index: item.offset, type: item.element.type, title: item.element.title)
                    }
                    
                    return nil
                }
                .first ?? (index: 0, type: items[0].type, title: items[0].title)
            }
    }
    
    func setSortType(_ type: SortType) {
        guard selectedSortType.value != type else {
            return
        }
        
        selectedSortType.accept(type)
        userData.setSort(type: type).save()
        
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
    
    func setWithinElements(_ elements:[WithinElement]?){
        if let items = elements {
            self.elements.accept(items)
        } else {
            self.elements.accept([])
        }
    }
}
