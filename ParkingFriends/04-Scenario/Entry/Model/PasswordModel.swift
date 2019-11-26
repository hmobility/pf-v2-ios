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
 //   var errorMessage: String { get }
    var data: BehaviorRelay<String> { get set }
  //  var errorValue: BehaviorRelay<String?> { get}

    func validateCredentials() -> Bool
}

class PasswordModel: NSObject, PasswordModelType {
   // var errorMessage: String = "Please enter a valid Passowrd"
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    //var errorValue: BehaviorRelay<String?> = BehaviorRelay(value: "")
    
    init(localizer: LocalizerType = Localizer.shared) {
    }

    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (size.minimum, size.maximum)) else {
       //     errorValue.accept(errorMessage)
            return false
        }
                
       // errorValue.accept("")
        return true
    }
    
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
