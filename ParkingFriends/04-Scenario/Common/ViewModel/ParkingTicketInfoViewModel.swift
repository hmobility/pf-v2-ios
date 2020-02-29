//
//  ParkingTicketInfoViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/25.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


protocol ParkingTicketInfoViewModelType {
    var parkinglotNameText: Driver<String> { get }
    var productNameText: Driver<String> { get }
    var paymentDateText: Driver<String> { get }
    var reservationDateText: Driver<String> { get }
    var reservationTimeText: Driver<String> { get }
    var reservationDateStartText: Driver<String> { get }
    var reservationDateEndText: Driver<String> { get }
    var carInfoText: Driver<String> { get }
}

class ParkingTicketInfoViewModel: ParkingTicketInfoViewModelType {
    var parkinglotNameText: Driver<String>
    var productNameText: Driver<String>
    var paymentDateText: Driver<String>
    var reservationDateText: Driver<String>
    var reservationTimeText: Driver<String>
    var reservationDateStartText: Driver<String>
    var reservationDateEndText: Driver<String>
    var carInfoText: Driver<String>
    
    var localizer:LocalizerType

    let disposeBag = DisposeBag()
    
    var parkinglotId:Int?
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
     
        parkinglotNameText = localizer.localized("ttl_parkinglot_name")
        productNameText = localizer.localized("ttl_product_purchased")
        paymentDateText = localizer.localized("ttl_payment_date")

        reservationDateText = localizer.localized("ttl_reservation_date")
        reservationTimeText = localizer.localized("ttl_reservation_time")
        
        reservationTimeText = localizer.localized("ttl_reservation_time")
        
        reservationDateStartText = localizer.localized("ttl_reservation_date_start")
        reservationDateEndText = localizer.localized("ttl_reservation_date_end")
        
        carInfoText = localizer.localized("ttl_car_info")
    }
}
