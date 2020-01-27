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
    var availableParkinglotText: Driver<String> { get }
    
    var availableTimeList: BehaviorRelay<[OperationTime]> { get }
    var onReserveTime: BehaviorRelay<DateDuration?> { get }
    
    func setProducts(_ elements:[ProductElement], onReserve time:DateDuration)
}

class ParkinglotDetailReserveViewModel: ParkinglotDetailReserveViewModelType {
    var viewTitleText: Driver<String>
    var availableParkinglotText: Driver<String>
    
    var availableTimeList: BehaviorRelay<[OperationTime]> = BehaviorRelay(value: [])
    var onReserveTime: BehaviorRelay<DateDuration?> = BehaviorRelay(value: nil)
    
    private var localizer:LocalizerType

    private let disposeBag = DisposeBag()

    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_detail_real_time_reserve_state")
        availableParkinglotText = localizer.localized("txt_detail_real_time_available_lots")
        
        //   initialize()
    }
 
    // MARK: - Public Methdos
    
    public func setProducts(_ elements:[ProductElement], onReserve time:DateDuration) {
        let timeList = elements.flatMap{ $0.availableTimes }
        availableTimeList.accept(timeList)
        onReserveTime.accept(time)
    }
}
