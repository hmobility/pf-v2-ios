//
//  ParkinglotDetailReverseViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/26.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailReserveViewModelType {
    var viewTitleText: Driver<String> { get }
    
    var availableTimeList: BehaviorRelay<[OperationTime]> { get }
    var bookingTime: BehaviorRelay<DateDuration?> { get }
    var supportedItems: BehaviorRelay<[ProductType]> { get }
    var availableCarNumber: BehaviorRelay<Int> { get }
    
    func getSupportedProducts() -> Observable<[(type:ProductType, title:String)]>
    func setProducts(supported products:[ProductType], elements:[ProductElement], onReserve time:DateDuration)
    func getAvailableParkinglotNumber() -> Observable<String>
    
    func setSelectedProductType(_ item:ProductType)
    func getSelectedProductType() -> Observable<ProductType?>
    //func getSelectedProduct() -> ProductElement?
}

class ParkinglotDetailReserveViewModel: ParkinglotDetailReserveViewModelType {
    var viewTitleText: Driver<String>
    
    var availableTimeList: BehaviorRelay<[OperationTime]> = BehaviorRelay(value: [])
    var bookingTime: BehaviorRelay<DateDuration?> = BehaviorRelay(value: nil)
    var supportedItems: BehaviorRelay<[ProductType]> = BehaviorRelay(value: [])
    var availableCarNumber: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    var selectedProductType: BehaviorRelay<ProductType?> = BehaviorRelay(value:nil)
    
    var localizer:LocalizerType

    let disposeBag = DisposeBag()

    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_detail_real_time_reserve_state")
    }
    
    // MARK: - Local Methods
    
    func getTicketTitle(with type: ProductType) -> ProductItemType {
        switch type {
        case .time:
            return (type, self.localizer.localized("ttl_ticket_time"))
        case .fixed:
            return (type, self.localizer.localized("ttl_ticket_fixed"))
        case .monthly:
            return (type, self.localizer.localized("ttl_ticket_monthly"))
        }
    }
    
    // MARK: - Public Methods
    
    public func setSelectedProductType(_ productType:ProductType) {
        selectedProductType.accept(productType)
    }
    
    public func getSelectedProductType() -> Observable<ProductType?> {
        return selectedProductType.asObservable()
    }
   
    public func getSupportedProducts() -> Observable<[(type:ProductType, title:String)]> {
        return supportedItems
            .map { items in
                return items.map {
                    self.getTicketTitle(with: $0)
                }
            }
    }
    
    public func getAvailableParkinglotNumber() -> Observable<String> {
        return availableCarNumber
            .asObservable()
            .map {
                let count = String($0)
                return self.localizer.localized("txt_detail_real_time_available_lots", arguments: count)
            }
    }
    
    public func setProducts(supported products:[ProductType], elements:[ProductElement], onReserve time:DateDuration) {
        let timeList = elements.flatMap{ $0.availableTimes }
        availableCarNumber.accept(elements.count)
        availableTimeList.accept(timeList)
        bookingTime.accept(time)
        
        if products.count > 0 {
            let sortedSupportedProducts = products.sorted(by: { $0.hashValue < $1.hashValue })
            supportedItems.accept(sortedSupportedProducts)
        }
    }
}
