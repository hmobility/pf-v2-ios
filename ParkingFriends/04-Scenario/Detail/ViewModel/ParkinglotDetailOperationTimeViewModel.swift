//
//  ParkinglotDetailOperationTimeViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/27.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailOperationTimeViewModelType {
    var viewTitleText: Driver<String> { get }
    var weekdayFieldText: Driver<String> { get }
    var saturdayFieldText: Driver<String> { get }
    var sundayFieldText: Driver<String> { get }
    var holidayFieldText: Driver<String> { get }
    var closedStateText: Driver<String> { get }
    
  //  var operationTimeList: BehaviorRelay<[ParkinglotOperationTime]> { get }
    
    func setOperationTimes(_ elements:[ParkinglotOperationTime])
    func getOperationTimeList() -> Observable<(OperationTimeType, String)>
}

class ParkinglotDetailOperationTimeViewModel: ParkinglotDetailOperationTimeViewModelType {
    var viewTitleText: Driver<String>
    var weekdayFieldText: Driver<String>
    var saturdayFieldText: Driver<String>
    var sundayFieldText: Driver<String>
    var holidayFieldText: Driver<String>
    var closedStateText: Driver<String>
    
    var operationTimeList: BehaviorRelay<[ParkinglotOperationTime]> = BehaviorRelay(value: [])
    
    private var localizer:LocalizerType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_detail_operating_time")
        weekdayFieldText = localizer.localized("ttl_operationg_time_weekday")
        saturdayFieldText = localizer.localized("ttl_operationg_time_saturday")
        sundayFieldText = localizer.localized("ttl_operationg_time_sunday")
        holidayFieldText = localizer.localized("ttl_operationg_time_holiday")
        closedStateText = localizer.localized("txt_day_closed")
    }
    
    // MARK: - Public Methods
    
    func setOperationTimes(_ elements:[ParkinglotOperationTime]) {
        operationTimeList.accept(elements)
    }
    
    func getOperationTimeList() -> Observable<(OperationTimeType, String)> {
        return operationTimeList
            .asObservable()
            .flatMap {
                Observable.from($0)
            }
            .filter {
                $0.operationFlag
            }
            .map {
                let time = DisplayTimeHandler().displayOperationTime(start: $0.from, end: $0.to)
                return ($0.type!, time)
            }
    }
}
