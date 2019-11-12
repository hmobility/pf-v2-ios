//
//  PhoneNumberModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

let size = (minimum:6, maximum:15)

protocol ValidationViewModel {
     
    var errorMessage: String { get }
    var data: BehaviorRelay<String> { get set }
    var errorValue: BehaviorRelay<String?> { get}

    func validateCredentials() -> Bool
}

class PhoneNumberModel: ValidationViewModel {
    var errorMessage: String = "Please enter a valid Passowrd"
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    var errorValue: BehaviorRelay<String?> = BehaviorRelay(value: "")

    func validateCredentials() -> Bool {
        guard validatePattern(text: data.value) else {
            errorValue.accept(errorMessage)
            return false
        }
        
        errorValue.accept("")
        return true
    }
    
    func validatePattern(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: text)
    }
}

class PasswordModel: ValidationViewModel {
    var errorMessage: String = "Please enter a valid Passowrd"
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    var errorValue: BehaviorRelay<String?> = BehaviorRelay(value: "")

    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (size.minimum, size.maximum)) else {
            errorValue.accept(errorMessage)
            return false
        }
                
        errorValue.accept("")
        return true
    }
    
    func validateLength(text: String, size: (min: Int, max:Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}
