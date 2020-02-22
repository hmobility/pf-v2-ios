//
//  PaymentReceiptViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/22.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentReceiptViewModelType {
    var closeText: Driver<String> { get }
    var sharingText: Driver<String> { get }
    
    func setOrderElement(with element:OrderElement)
    func getReceipt() -> Observable<Receipt>
}

class PaymentReceiptViewModel: PaymentReceiptViewModelType {
    var closeText: Driver<String>
    var sharingText: Driver<String>
    
    var recieptItem:BehaviorRelay<Receipt?> = BehaviorRelay(value: nil)
    
    var element:OrderElement?
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        closeText = localizer.localized("btn_close")
        sharingText = localizer.localized("btn_to_share")
    }
    
    // MARK: - Local Methods
    
    func upateOrderItem(_ item:OrderElement) {
        element = item
    }
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement) {
        self.element = element
    }
    
    public func getReceipt() -> Observable<Receipt> {
        return loadReceipt()
            .filter { $0 != nil }
            .map { $0! }
    }
    
    // MARK: - Network
    
    private func loadReceipt() -> Observable<Receipt?> {
        if recieptItem.value != nil {
            return recieptItem.asObservable()
        } else {
            if let id = element?.id {
                return Order.receipt(id: id)
                    .asObservable()
                    .filter { (item, status) in
                        item != nil
                    }
                    .map { (item, status) in
                        return item
                    }
            } else {
                return Observable.just(nil)
            }
        } 
    }
    
    private func shareReceipt() {
   //     Order.receipt_send(id: Int, sentType: ReceiptSendType, phoneNumber: String, email: String)
    }
}
