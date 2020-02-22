//
//  ParkingStatusViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


protocol ParkingStatusViewModelType {
    var viewTitleText: Driver<String> { get }
    
    var parkingStatusDescText: Driver<String> { get }
    
    func getGuideText() -> Observable<String>
    
    func setOrderElement(_ element:OrderElement)
    func getCctvStatus() -> Observable<(supported:Bool, urls:[String], elapsedMinutes:Int)>
   // func loadUsages() -> Observable<Usages?>
}

class ParkingStatusViewModel: ParkingStatusViewModelType {
    var viewTitleText: Driver<String>
    var parkingStatusDescText: Driver<String>
    var confirmText: Driver<String>
    var usageItem: BehaviorRelay<Usages?> = BehaviorRelay(value: nil)
    var orderElement: OrderElement?
    
    var localizer:LocalizerType
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer

        viewTitleText = localizer.localized("ttl_parking_status")
        parkingStatusDescText = localizer.localized("dsc_parking_time_remaining")
        
        confirmText = localizer.localized("btn_yes")
    }
    
    // MARK: - Public Methods
    
    public func getGuideText() -> Observable<String> {
        return loadUsages()
            .filter { $0 != nil }
            .map { $0! }
            .map {
                let elapsedTime = $0.elapsedMinutes
                return self.localizer.localized("ttl_parking_time_remaining", arguments: elapsedTime) as String
            }
    }
    
    public func setOrderElement(_ element:OrderElement) {
        orderElement = element
    }
    
    public func getCctvStatus() -> Observable<(supported:Bool, urls:[String], elapsedMinutes:Int)> {
        return loadUsages()
            .filter { $0 != nil }
            .map { $0! }
            .map {
                if $0.camIds.count > 0 {
                    return (supported:true, urls: $0.camIds, elapsedMinutes: $0.elapsedMinutes)
                } else {
                    return (supported:false, urls: $0.camIds,elapsedMinutes: $0.elapsedMinutes)
                }
            }
    }
    
    // MARK: - Local Methods
    
    func updateUsageItem(_ item:Usages) {
        usageItem.accept(item)
    }
    
    // MARK: - Network
    
    func loadUsages() -> Observable<Usages?> {
        if let element = orderElement {
            if usageItem.value != nil {
                return usageItem.asObservable()
                    .filter { $0 != nil }
            } else {
                return Order.mypage_usages(id: element.id)
                    .asObservable()
                    .filter { (usages, status) in
                        status == .success && usages != nil
                    }
                    .map { [unowned self] (usages, status) in
                        self.updateUsageItem(usages!)
                        return usages
                    }
            }
        } else {
            return Observable.just(nil)
        }
    }
}
