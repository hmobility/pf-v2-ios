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
    
    func validate() -> CheckType
    func message(_ type:CheckType) -> String
}

class CarNumberModel: CarNumberModelType {
    var number: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    func validate() -> CheckType {
        guard number.value.count > 0  else {
            return .none
        }
                   
        if self.number.value.matches("^\\d{2}[가-힣]{1}\\d{4}$") || self.number.value.matches("^[가-힣]{2}\\d{2}[가-힣]{1}\\d{4}$") ||
            self.number.value.matches("^\\d{3}[가-힣]{1}\\d{4}$") {
            return .valid
        }
        
        return .invalid
    }
    
    func message(_ type:CheckType) -> String {
        switch type {
        case .invalid:
            return self.localizer.localized("msg_car_number_invalid")
        default:
            return ""
        }
    }
    
}
