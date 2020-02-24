//
//  CardPaymentModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import AnyFormatKit

public enum CreditCardSectionType {
    case number, expiration_date, password, resident_number, holder_name
    
    static var allSections: [CreditCardSectionType] {
        return [.number, .expiration_date, .password, .resident_number, .holder_name]
    }
}

public typealias CreditCardInfo = (number:String, expirationYear:String, expirationMonth:String, password:String, residentNumber:String, holder:String)

public let creditCardFormatter = DefaultTextInputFormatter(textPattern:  "#### #### #### ####")
public let expirationFormatter = DefaultTextInputFormatter(textPattern:  "##/##")

let cardInfoLength = (number:16, expirationDigits:2, residentNumber:6, password:2)
let nameLength = (minimum:1, maximum:18)

public protocol CreditCardModelType {
    var cardNumber: BehaviorRelay<String> { get set }
    var expirationMonth: BehaviorRelay<String> { get set }
    var expirationYear: BehaviorRelay<String> { get set }
    var birthDate: BehaviorRelay<String> { get set }
    var password: BehaviorRelay<String> { get set }
    var holderName: BehaviorRelay<String> { get set }
    var residentNumber: BehaviorRelay<String> { get set }
    
    var creditCard:CreditCardInfo { get }
    
    func message(section:CreditCardSectionType, check:CheckType) -> String
    func validate(type:CreditCardSectionType) -> (check:CheckType, message:String)
    func accept(_ text:String, type:CreditCardSectionType)
    func formatted(section:CreditCardSectionType, textField:UITextField, range:NSRange, replacement:String) -> String?
}

final class CreditCardModel: CreditCardModelType {
    var cardNumber: BehaviorRelay<String> = BehaviorRelay(value:"")
    var expirationMonth: BehaviorRelay<String> = BehaviorRelay(value:"")
    var expirationYear: BehaviorRelay<String> = BehaviorRelay(value:"")
    var birthDate: BehaviorRelay<String> = BehaviorRelay(value:"")
    var password: BehaviorRelay<String> = BehaviorRelay(value:"")
    var holderName: BehaviorRelay<String> = BehaviorRelay(value:"")
    var residentNumber: BehaviorRelay<String> = BehaviorRelay(value:"")
    
    var creditCard:CreditCardInfo {
        get {
            return (number:cardNumber.value, expirationYear:expirationYear.value, expirationMonth:expirationMonth.value, password:password.value, residentNumber:residentNumber.value, holder:holderName.value)
        }
    }
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    func message(section:CreditCardSectionType, check: CheckType) -> String {
        if check == .invalid {
            return self.localizer.localized("msg_credit_card_field_invalid")
        }
        
        return ""
    }
    
    func validate(type:CreditCardSectionType) -> (check:CheckType, message:String) {
        var text:String = ""
        var result = false
            
        switch type {
        case .number:
            text = cardNumber.value
            result = (text.count == cardInfoLength.number)
        case .expiration_date:
            let year = expirationYear.value
            let month = expirationMonth.value
            text = "\(year)+\(month)"
            result = (year.count == cardInfoLength.expirationDigits && month.count == cardInfoLength.expirationDigits)
        case .password:
            text = password.value
            result = (text.count == cardInfoLength.password)
        case .resident_number:
            text = residentNumber.value
            result = (text.count == cardInfoLength.residentNumber)
        case .holder_name:
            text = holderName.value as String
            result = text.validateLength(size: (min:nameLength.minimum, max:nameLength.maximum))
        }
            
        let check:CheckType = (text.isEmpty ? .none : (result ? .valid : .invalid))
        let message = (check == .none) ? "" : self.message(section:type, check: (result ? .valid : .invalid))
            
        return (check, message)
    }
    
    func accept(_ text:String, type:CreditCardSectionType) {
        switch type {
        case .number:
            if let unformattedString = unformatted(text, section:type) {
                cardNumber.accept(unformattedString)
            }
        case .expiration_date:
            let date = text.split(separator: "/")
            
            if date.count  == 2 {
                expirationMonth.accept(String(date[0]))
                expirationYear.accept(String(date[1]))
            } else {
                expirationMonth.accept("")
                expirationYear.accept("")
            }
        case .password:
            password.accept(text)
        case .resident_number:
            residentNumber.accept(text)
        case .holder_name:
            holderName.accept(text)
        }
    }
        
    func formatted(section:CreditCardSectionType, textField:UITextField, range:NSRange, replacement:String) -> String? {
        var text:String?
        
        switch section {
        case .number:
            text = shouldChangeCharactersIn(formatter: creditCardFormatter, textField:textField, range:range, replacement:replacement)
        case .expiration_date:
            text = shouldChangeCharactersIn(formatter: expirationFormatter, textField:textField, range:range, replacement:replacement)
        default:
            return nil
        }
        
        if let result = text {
            self.accept(result, type:section)
        }
        
        return text
    }
    
    // MARK: - Local Methods
    
    func unformatted(_ text:String, section:CreditCardSectionType) -> String? {
        switch section {
        case .number:
            return creditCardFormatter.unformat(text)
        case .expiration_date:
            return expirationFormatter.unformat(text)
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
