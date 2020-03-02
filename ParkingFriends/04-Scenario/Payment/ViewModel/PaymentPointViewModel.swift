//
//  PaymentPointViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol PaymentPointViewModelType {
    var viewTitleText: Driver<String> { get }
    var userPointsFieldText: Driver<String> { get }
    var pointsInputPlaceholder: Driver<String> { get }
    var noPointsText: Driver<String> { get }
    var userPointsText: Driver<String> { get }
    var useAllPointsText: Driver<String> { get }
    var placeholderInputPointsText: Driver<String> { get }
    var pointsToUseLimitText: Driver<String> { get }
    
    func setUserPoints(_ points:Int)
    func getUserPoints() -> Observable<Int?>
    func getAllPoints() -> Int
}

class PaymentPointViewModel: PaymentPointViewModelType {
    var viewTitleText: Driver<String>
    var userPointsFieldText: Driver<String>
    var pointsInputPlaceholder: Driver<String>
    var noPointsText: Driver<String>
    var userPointsText: Driver<String>
    var useAllPointsText: Driver<String>
    var placeholderInputPointsText: Driver<String>
    var pointsToUseLimitText: Driver<String>
    
    var userPoints:BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_payment_point")
        userPointsFieldText = localizer.localized("ttl_payment_point")
        pointsInputPlaceholder = localizer.localized("ph_input_payment_points")
        noPointsText =  localizer.localized("txt_payment_no_point")
        userPointsText = localizer.localized("txt_payment_user_points")
        useAllPointsText = localizer.localized("btn_use_all_points")
        pointsToUseLimitText = localizer.localized("msg_payment_point_limit")
            
        placeholderInputPointsText = localizer.localized("ph_input_payment_points")
    }
    
    // MARK: - Public Methods
    
    public func setUserPoints(_ points:Int) {
        userPoints.accept(points)
    }
      
    public func getUserPoints() -> Observable<Int?> {
        return userPoints
            .asObservable()
    }
    
    public func getAllPoints() -> Int {
        return userPoints.value ?? 0
    }
}
