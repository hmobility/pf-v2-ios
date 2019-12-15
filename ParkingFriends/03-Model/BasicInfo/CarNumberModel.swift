//
//  CarInfoModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/09.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

public protocol CarNumberModelType {
    var number: BehaviorRelay<String> { get set }
    
    func validate() -> Bool
}

class CarNumberModel: CarNumberModelType {
    var number: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    func validate() -> Bool {
        if self.number.value.matches("^\\d{2}[가-힣]{1}\\d{4}$") || self.number.value.matches("^[가-힣]{2}\\d{2}[가-힣]{1}\\d{4}$") ||
            self.number.value.matches("^\\d{3}[가-힣]{1}\\d{4}$") {
            return true
        }
        
        return false
    }
    
}
