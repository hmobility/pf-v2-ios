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
    var noPointsText: Driver<String> { get }
    var userPointsText: Driver<String> { get }
    var useAllPointsText: Driver<String> { get }
    var placeholderInputPointsText: Driver<String> { get }
    
    func setUserPoints(_ points:Int)
    func getUserPoints() -> Observable<Int>
}

class PaymentPointViewModel: PaymentPointViewModelType {
    var viewTitleText: Driver<String>
    var noPointsText: Driver<String>
    var userPointsText: Driver<String>
    var useAllPointsText: Driver<String>
    var placeholderInputPointsText: Driver<String>
    
    var userPoints:BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_payment_point")
        noPointsText =  localizer.localized("txt_payment_no_point")
        userPointsText = localizer.localized("txt_payment_user_points")
        useAllPointsText = localizer.localized("btn_use_all_points")
        
        placeholderInputPointsText = localizer.localized("ph_input_payment_points")
    }
    
    // MARK: - Public Methods
    
    public func setUserPoints(_ points:Int) {
        userPoints.accept(points)
    }
      
    public func getUserPoints() -> Observable<Int> {
        return userPoints
            .asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }
}
