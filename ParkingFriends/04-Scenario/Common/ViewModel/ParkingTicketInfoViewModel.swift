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
    var noCarInfoText: Driver<String> { get }
    var addCarText: Driver<String> { get }
    var changeCarText: Driver<String> { get }
    
    func setUsageInfo(_ item:Usages)
    func getUsageInfo() -> Observable<Usages>
    
    func setOrderPreview(_ item:OrderPreview)
    func getOrderPreview() -> Observable<OrderPreview>
    
    func setCarNumber(_ carNumber:String)
    func getCarNumber() -> Observable<String>
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
    var noCarInfoText: Driver<String>
    var addCarText: Driver<String>
    var changeCarText: Driver<String>
    
    var infoUsage:BehaviorRelay<Usages?> = BehaviorRelay(value: nil) //  Order-Usage
    var infoPreview:BehaviorRelay<OrderPreview?> = BehaviorRelay(value: nil) //  Order-Preview
    var carNumberText:BehaviorRelay<String?> = BehaviorRelay(value:nil)
    
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
        noCarInfoText = localizer.localized("txt_car_info_no_registerd")
        addCarText = localizer.localized("btn_car_add")
        changeCarText = localizer.localized("btn_car_change")
    }
    
    // MARK: - Public Methods
    
    public func setUsageInfo(_ item:Usages) {
        infoUsage.accept(item)
    }
    
    public func getUsageInfo() -> Observable<Usages> {
        return infoUsage
            .asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }
    
    public func setOrderPreview(_ item:OrderPreview) {
        infoPreview.accept(item)
    }
    
    public func getOrderPreview() -> Observable<OrderPreview> {
        return infoPreview
            .asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }
    
    public func setCarNumber(_ carNumber:String) {
        carNumberText.accept(carNumber)
    }
    
    public func getCarNumber() -> Observable<String> {
        return carNumberText
            .asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }
    
    // MARK: - Shared Model
    
    static var shared:ParkingTicketInfoViewModelType {
        if ParkingTicketInfoViewModel.sharedManager == nil {
            ParkingTicketInfoViewModel.sharedManager = ParkingTicketInfoViewModel()
        }
        
        return ParkingTicketInfoViewModel.sharedManager
    }
      
    private static var sharedManager:ParkingTicketInfoViewModelType!
}
