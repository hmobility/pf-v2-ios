//
//  EmailModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

public protocol EmailModelType {
    var data: BehaviorRelay<String> { get set }
    
    func message(_ type:CheckType) -> String
}

final class EmailModel {
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    func validateCredentials() -> Bool {
        guard data.value.validatePattern(type: .email) else  {
            return false
        }
        
        return true
    }
    
    func clear() {
        data.accept("")
    }
    
    func message(_ type:CheckType) -> String {
        switch type {
        case .invalid:
            return self.localizer.localized("msg_email_format_invalid")
        default:
            return ""
        }
    }
}
