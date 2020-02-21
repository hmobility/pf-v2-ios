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
    
    var parkingStatusGuideText: Driver<String> { get }
    var parkingStatusDescText: Driver<String> { get }
    
    func setOrderElement(_ element:OrderElement)
    func getCctvStatus() -> Observable<(supported:Bool, urls:[String], elapsedMinutes:Int)>
    func loadUsages()  
}

class ParkingStatusViewModel: ParkingStatusViewModelType {
    var viewTitleText: Driver<String>
    var parkingStatusGuideText: Driver<String>
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
        parkingStatusGuideText = localizer.localized("ttl_parking_time_remaining")
        parkingStatusDescText = localizer.localized("dsc_parking_time_remaining")
        
        confirmText = localizer.localized("btn_yes")
    }
    
    // MARK: - Public Methods
    
    public func setOrderElement(_ element:OrderElement) {
        orderElement = element
    }
    
    public func getCctvStatus() -> Observable<(supported:Bool, urls:[String], elapsedMinutes:Int)> {
        return usageItem.asObservable()
                .filter { $0 != nil}
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
    
    // MARK: - Network
    
    func loadUsages()  {
        guard let element = orderElement else {
            return
        }
        
        Order.mypage_usages(id: element.id)
            .asObservable()
            .filter { (usages, status) in
                status == .success
            }
            .map { (usages, status) in
                return usages!
            }
            .bind(to: usageItem)
            .disposed(by: disposeBag)
    }
}
