//
//  PhoneNumberModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit
import AnyFormatKit

fileprivate let size = (minimum:6, maximum:15)

public protocol PasswordModelType {
    var data: BehaviorRelay<String> { get set }

    func validateCredentials() -> Bool
    func message(_ type:CheckType) -> String
}

class PasswordModel: NSObject, PasswordModelType {
   
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private var localizer:LocalizerType
    
    // MARK: - Localize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    // MARK: - Public Methods

    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (size.minimum, size.maximum)) else {
       //     errorValue.accept(errorMessage)
            return false
        }
                
       // errorValue.accept("")
        return true
    }
    
    func message(_ type:CheckType) -> String {
        switch type {
        case .invalid:
            return self.localizer.localized("msg_pw_format_invalid")
        default:
            return ""
        }
    }
    
    // MARK: - Local Methods
    
    func validateLength(text: String, size: (min: Int, max:Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}

// MARK: - UITextFieldDelegate

extension PasswordModel:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = textField.text?.count ?? 0
        
        if range.length + range.location > count {
            return false
        }
        
        let newLength = count + string.count - range.length
        
        return newLength <= size.maximum
    }
}
