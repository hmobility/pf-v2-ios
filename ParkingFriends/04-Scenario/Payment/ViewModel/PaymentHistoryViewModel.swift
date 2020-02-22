//
//  PaymentHistoryViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentHistoryViewModelType {
    var viewTitleText: Driver<String> { get }
    var ticketUsedTitleText: String { get }
    var ticketNotUsedTitleText: String { get }
    
    func getTapItems() -> Observable<[String]>
    func getOrderItems(_ tapIndex:PaymentHistoryTapIndex) -> Observable<[OrderElement]>
    
    func getPaidItems() -> Observable<[OrderElement]>
    func getUsedItems() -> Observable<[OrderElement]>
    
    //func loadOrderItems()
}

class PaymentHistoryViewModel: PaymentHistoryViewModelType {
    var viewTitleText: Driver<String>
    var ticketUsedTitleText: String
    var ticketNotUsedTitleText: String
    
    var historyInfoItems: BehaviorRelay<[OrderElement]?> = BehaviorRelay(value: nil)
    
    var paidInfoItems: BehaviorRelay<[OrderElement]?> = BehaviorRelay(value: nil)
    var usedInfoItems: BehaviorRelay<[OrderElement]?> = BehaviorRelay(value: nil)
    
    var localizer:LocalizerType
    
    let disposeBag = DisposeBag()
    
    let paidOptions:[OrderStatusType] = [.paid, .parking]
    let usedOptions:[OrderStatusType] = [.refunded, .finished, .cancel_request]
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    
        viewTitleText = localizer.localized("ttl_payment_for_parking")
        ticketUsedTitleText = localizer.localized("ttl_payment_history_not_used")
        ticketNotUsedTitleText = localizer.localized("ttl_payment_history_used")
    }
    
    // MARK: - Public Methods
    
    public func getTapItems() -> Observable<[String]> {
        return Observable.of([ticketUsedTitleText, ticketNotUsedTitleText])
    }
    
    public func getPaidItems() -> Observable<[OrderElement]> {
        if paidInfoItems.value != nil {
            return self.paidInfoItems
                .asObservable()
                .filter { $0 != nil }
                .map { $0! }
        } else {
            return loadOrderItems(with: paidOptions)
                .map { item in
                    self.updatePaidItems(item)
                    return item
                }
        }
    }
    
    public func getUsedItems() -> Observable<[OrderElement]> {
        if usedInfoItems.value != nil {
            return self.usedInfoItems
                .asObservable()
                .filter { $0 != nil }
                .map { $0! }
        } else {
            return loadOrderItems(with: usedOptions)
                .map { item in
                    self.updateUsedItems(item)
                    return item
                }
        }
    }
    
    public func getOrderItems(_ tapIndex:PaymentHistoryTapIndex) -> Observable<[OrderElement]> {
        let productSatus:OrderStatusType = (tapIndex == .reserved_history) ? .paid : .cancel_request
        
        return historyInfoItems
            .filter { $0 != nil }
            .map { $0! }
            .asObservable()
            .map { items in
                return items.filter { $0.status == productSatus }
            }
    }
    
    // MARK: - Local Methods
    
    private func updatePaidItems(_ elements:[OrderElement]) {
        paidInfoItems.accept(elements)
    }
    
    private func updateUsedItems(_ elements:[OrderElement]) {
        usedInfoItems.accept(elements)
    }
    
    // MARK: - Network
       
    public func loadOrderItems(with options:[OrderStatusType]) -> Observable<[OrderElement]> {
        return Order.orders(page: 0, from: "", to: "", status: options)
            .asObservable()
            .filter { (orders, status) in
                orders != nil
            }
            .map { (orders, status) in
                return orders!
            }
            .map { orders in
                return orders.elements
            }
            /*
            .bind(to: historyInfoItems)
            .disposed(by: disposeBag)
 */
    }
}
