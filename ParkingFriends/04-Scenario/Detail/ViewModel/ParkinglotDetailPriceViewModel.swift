//
//  ParkinglotDetailPriceViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/28.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailPriceViewModelType {
    var viewTitleText: Driver<String> { get }
    
    var supportedItems:BehaviorRelay<[ProductType]> { get }
    var products:BehaviorRelay<[ProductElement]> { get }
    
    func setSupported(_ items:[ProductType], fee:Fee?)
    
    func isAvailable() -> Observable<Bool>
    
    func getTimeTicketList() -> Observable<(title:String, price:String)>
    func getExtraFee() -> Observable<String>
    
    func getFixedTicketList() -> Observable<(title:String, price:String)>
    func getMonthlyTicketList() -> Observable<(index:Int, title:String, price:String)>
}

class ParkinglotDetailPriceViewModel: ParkinglotDetailPriceViewModelType {
    var viewTitleText: Driver<String>
    
    var supportedItems:BehaviorRelay<[ProductType]> = BehaviorRelay(value: [])
    var products:BehaviorRelay<[ProductElement]> = BehaviorRelay(value: [])             // 별개의 가격정보 리스트로 제공 되지 않아 ProductElement 를 사용
    
    private var baseFee:BehaviorRelay<Fee?> = BehaviorRelay(value: nil)
    
    private var localizer:LocalizerType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_detail_price_table")
    }
    
    // MARK: - Public Methods
    
    func setSupported(_ items:[ProductType], fee:Fee?) {
        supportedItems.accept(items)
        baseFee.accept(fee)
    }
    
    func isAvailable() -> Observable<Bool> {
        return supportedItems
            .asObservable()
            .map { items -> Bool in
                return items.count > 0
            }
    }
    
    func getTimeTicketList() -> Observable<(title:String, price:String)> {
        return baseFee.asObservable()
            .distinctUntilChanged()
            .filter ({
                return ($0 != nil)
            })
            .map { $0! }
            .map ({ fee in
                let title = self.localizer.localized("ttl_ticket_time") as String
                
                let minutes = fee.minute
                let price = (minutes >= 60) ? (minutes / 60) : minutes
                let priceUnit = self.localizer.localized("txt_money_unit") as String
                let timeUnit:String = (minutes >= 60) ? self.localizer.localized("txt_hours") : self.localizer.localized("txt_minutes")
                
                return (title:title, price:"\(price.withComma)\(priceUnit) / \(timeUnit)")
            })
    }
    
    func getExtraFee() -> Observable<String> {
        return baseFee.asObservable()
            .filter({
                return ($0 != nil)
            })
            .map { $0! }
            .map { fee -> String in
                let minutes = String(fee.addMinute)
                let timeUnit:String = (fee.addMinute >= 60) ? self.localizer.localized("txt_hours") : self.localizer.localized("txt_minutes")
                let text = self.localizer.localized("txt_detail_time_extra_fee", arguments: minutes, timeUnit) as String
                
                return text
            }
    }
    
    func getFixedTicketList() -> Observable<(title:String, price:String)> {
        return products.asObservable()
            .distinctUntilChanged()
            .flatMap {
                Observable.from($0)
            }
            .filter {
                $0.type == .fixed
            }
            .map { element in
                return (title: element.name, price: element.price.withComma)
            }
    }
    
    func getMonthlyTicketList() -> Observable<(index:Int, title:String, price:String)> {
        return products.asObservable()
            .distinctUntilChanged()
            .flatMap {
                Observable.from($0)
            }
            .filter {
                $0.type == .monthly
            }
            .enumerated()
            .map { (index, element) in
                let title = self.localizer.localized("ttl_ticket_monthly") as String
                return (index: index, title: title, price: element.descript)
            }
    }
}
