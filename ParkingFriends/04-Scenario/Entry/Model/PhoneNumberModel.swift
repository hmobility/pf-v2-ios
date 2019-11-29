//
//  PhoneNumberModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit
import AnyFormatKit

fileprivate let phone_number_digits = 11

public protocol PhoneNumberModelType {
    var data: BehaviorRelay<String> { get set }
    var phoneNumber:String? { get }
    var valid:BehaviorRelay<Bool> { get }
    
    func validatePattern() -> Bool
    
    static func formatted(_ number:String) -> String?
}

public let phoneFormatter = DefaultTextInputFormatter(textPattern:  "###-####-####")

class PhoneNumberModel: NSObject, PhoneNumberModelType {
    
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    var phoneNumber: String? {
        get {
            phoneFormatter.unformat(data.value)
        }
    }
    var valid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    override init() {
        super.init()
    }
    
    init(localizer: LocalizerType = Localizer.shared) {
    }
    
    // MARK: - Local Methods
    
    private func updateStatus(_ updated:String = "") {
        self.data.accept(updated)
        let finished = validatePattern()
        self.valid.accept(finished)
    }
    
    // MARK: - Public Methods
    
    static func formatted(_ number:String) -> String? {
        return phoneFormatter.format(number)
    }
    
    // Check Syntax
    func validatePattern() -> Bool {
        print("[VALIDATE] ", data.value)
        return data.value.validatePattern(type: .phone_number)
    }
    
    // MARK: - Local Methods
}

// MARK: - UITextFieldDelegate

extension PhoneNumberModel:UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateStatus()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let result = phoneFormatter.formatInput(currentText: text, range: range, replacementString: string)
            print("(INPUT)", result)
            textField.text = result.formattedText
            textField.setCursorLocation(result.caretBeginOffset)
            updateStatus(result.formattedText)
            return false
        }
        
        return true
    }
}
