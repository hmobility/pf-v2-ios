//
//  String+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/19.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

public enum patternType {
    case phone_number
    case email
}

typealias validSize = (min:Int, max:Int)

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    var intValue: Int {
        return Int((self as NSString).intValue)
    }
    
    func first(char:Int) -> String {
        return String(self.prefix(char))
    }

    func last(char:Int) -> String {
        return String(self.suffix(char))
    }
}


// MARK: - Pattern Matching

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func validatePattern(type: patternType) -> Bool {
        var regEx:String
        
        switch type {
        case .phone_number:
            regEx = "^\\d{3}-\\d{4}-\\d{4}$"
        case .email:
            regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        }
        
        let stringTest = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return stringTest.evaluate(with: self)
    }
    
    func validateLength(size:validSize) -> Bool {
        return (size.min...size.max).contains(self.count)
    }
    
    func stringFromSecondsInterval(seconds: Int) -> String {
        return String(format: "%0.2d:%0.2d", arguments: [(seconds % 3600) / 60, (seconds % 3600) % 60])
    }
}
