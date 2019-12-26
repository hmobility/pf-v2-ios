//
//  UserInfoModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/24.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import AnyFormatKit

public enum UserInfoSectionType {
    case phone_number, email, password, nickname
    
    static var checkSections: [UserInfoSectionType] {
        return [.email, .password, .nickname]
    }
}

public protocol UserInfoModelType {
    var phoneNumber: BehaviorRelay<String> { get set }
    var email: BehaviorRelay<String> { get set }
    var nickname: BehaviorRelay<String> { get set }
    var password: BehaviorRelay<String> { get set }
    
    var userData:(phoneNumber:String, email:String, password:String, nickname:String) { get }
    
    func message(section:UserInfoSectionType, check:CheckType) -> String
    func validate(type:UserInfoSectionType) -> (check:CheckType, message:String)
    func formatted(section:UserInfoSectionType, textField:UITextField, range:NSRange, replacement:String) -> String?
    func formatted(section:UserInfoSectionType) -> String?
    func accept(_ text:String, type:UserInfoSectionType)
}

public let phoneFormatter = DefaultTextInputFormatter(textPattern:  "###-####-####")

fileprivate let phone_number_digits = 11
fileprivate let password_size = validSize(min:8, max:15)
fileprivate let nickname_size = validSize(min:1, max:15)

final class UserInfoModel: UserInfoModelType {
    var phoneNumber: BehaviorRelay<String> = BehaviorRelay(value: "")
    var email: BehaviorRelay<String> = BehaviorRelay(value: "")
    var nickname: BehaviorRelay<String> = BehaviorRelay(value: "")
    var password: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var userData:(phoneNumber:String, email:String, password:String, nickname:String) {
        get {
            return (phoneNumber: phoneNumber.value, email: email.value, password: nickname.value, nickname: password.value)
        }
    }
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    func message(section:UserInfoSectionType, check: CheckType) -> String {
        if check == .invalid {
            return self.localizer.localized("msg_credit_card_field_invalid")
        }
        
        return ""
    }
    
    func validate(type:UserInfoSectionType) -> (check:CheckType, message:String) {
        var text:String = ""
        var result = false
            
        switch type {
        case .phone_number:
            text = phoneNumber.value
            result = (text.count == phone_number_digits)
        case .email:
            text = email.value
            result = email.value.validatePattern(type: .email)
        case .password:
            text = password.value
            result = text.validateLength(size: password_size)
        case .nickname:
            text = nickname.value
            result = text.validateLength(size: nickname_size)
        }

        let check:CheckType = (text.isEmpty ? .none : (result ? .valid : .invalid))
        let message = (check == .none) ? "" : self.message(section:type, check: (result ? .valid : .invalid))
            
        return (check, message)
    }
    
    func accept(_ text:String, type:UserInfoSectionType) {
        switch type {
        case .phone_number:
            if let unformattedString = unformatted(text, section:type) {
                phoneNumber.accept(unformattedString)
            }
        case .password:
            password.accept(text)
        case .email:
            email.accept(text)
        case .nickname:
            nickname.accept(text)
        }
    }
    
    func formatted(section:UserInfoSectionType) -> String? {
        switch section {
        case .phone_number:
            let text = self.phoneNumber.value
            return phoneFormatter.format(text)
        default:
            return nil
        }
    }
    
    func formatted(section:UserInfoSectionType, textField:UITextField, range:NSRange, replacement:String) -> String? {
        var text:String?
        
        switch section {
        case .phone_number:
            text = shouldChangeCharactersIn(formatter: phoneFormatter, textField:textField, range:range, replacement:replacement)
        default:
            return nil
        }
        
        if let result = text {
            self.accept(result, type:section)
        }
        
        return text
    }
    
    // MARK: - Local Methods
    
    func unformatted(_ text:String, section:UserInfoSectionType) -> String? {
        switch section {
        case .phone_number:
            return phoneFormatter.unformat(text)
        default:
            return nil
        }
    }
    
    func shouldChangeCharactersIn(formatter:DefaultTextInputFormatter, textField: UITextField, range: NSRange, replacement: String) -> String? {
        if let text = textField.text {
            let textValue:FormattedTextValue = formatter.formatInput(currentText:text, range:range, replacementString:replacement)
            
            textField.text = textValue.formattedText
            textField.setCursorLocation(textValue.caretBeginOffset)
            
            return textValue.formattedText
        }
        
        return nil
    }
}
