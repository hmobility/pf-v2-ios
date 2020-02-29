//
//  PaymentViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/29.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentViewModelType {
    var viewTitleText: Driver<String> { get }
    var paymentText: BehaviorRelay<String> { get }
    
    var giftMode:BehaviorRelay<Bool> { get }
    
    func setGiftMode(_ flag:Bool)
    func setProductElement(_ element:ProductElement)
    func setParkinglotInfo(_ item:Parkinglot)
    
    func getOrderPreview() -> Observable<OrderPreview?>
    
    func setOrderForm(_ form:TicketOrderFormType)
}

class PaymentViewModel: PaymentViewModelType {
    var viewTitleText: Driver<String>
    var paymentText: BehaviorRelay<String>
    
    var orderPreviewItem:BehaviorRelay<OrderPreview?> = BehaviorRelay(value: nil)
    var giftMode:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var productElement:ProductElement?
    var parkingLotInfo:Parkinglot?
    
    var orderForm:TicketOrderFormType?
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
     
        viewTitleText = localizer.localized("ttl_payment_for_parking")
        paymentText = BehaviorRelay(value: localizer.localized("btn_to_pay"))
    }
    
    // MARK: - Public Methods
    
    public func setOrderForm(_ form:TicketOrderFormType) {
        orderForm = form
    }
    
    public func setProductElement(_ element:ProductElement) {
        productElement = element
    }
    
    public func setParkinglotInfo(_ item:Parkinglot) {
        parkingLotInfo = item
    }
    
    public func setGiftMode(_ flag:Bool) {
        giftMode.accept(flag)
        /*
        if flag {
            paymentText.accept(localizer.localized("btn_to_pay"))
        } else {
            paymentText.accept(localizer.localized("btn_to_pay"))
        }
         */
    }
    
    func getOrderPreview() -> Observable<OrderPreview?> {
        if let form = orderForm {
            let productId = form.productId ?? 0
            let from = form.from?.toString(format:.custom("yyyyMMddHHmmss")) ?? ""
            let to = form.to?.toString(format:.custom("yyyyMMddHHmmss")) ?? ""
           
            return requestOrderPreview(type: form.type, parkingLotId: form.parkingLotId, productId: productId
                , form: from, to: to, quantity: form.quantity)
        } else {
            return Observable.just(nil)
        }
        /*
        if let item = parkingLotInfo, let element = item.products.first, let productType = element.type, let time = element.availableTimes.first {
            
            
            if let form = orderForm {
                let from = time.from.toDate?.toString(format: .custom("yyyyMMddHHmmss"))
                let to = time.to.toDate?.toString(format: .custom("yyyyMMddHHmmss"))
            
            return requestOrderPreview(type: productType, parkingLotId: item.id, productId: element.id
                , form: from!, to: to!, quantity: 1)
        } else {
            return Observable.just(nil)
        }
 */
    }

    // MARK: - Local Methods
    
    func updateOrderPreviewItem(_ item:OrderPreview) {
        orderPreviewItem.accept(item)
    }
    
    // MARK: - Network
    
    func requestOrderPreview(type:ProductType, parkingLotId:Int, productId:Int, form:String, to:String, quantity:Int) -> Observable<OrderPreview?> {
        if orderPreviewItem.value != nil {
            return orderPreviewItem
                .asObservable()
                .filter { $0 != nil }
        } else {
            return Order.preview(type: type, parkingLotId: parkingLotId, productId: productId, from: form, to: to, quantity: quantity)
                .asObservable()
                .filter { (item, status) in
                     status == .success && item != nil
                }
                .map {[unowned self] (item, status) in
                    self.updateOrderPreviewItem(item!)
                    return item
                }
        }
    }
}
