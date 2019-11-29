//
//  RxTextFieldDelegateProxy.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/21.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

open class RxTextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {
    
    public weak private(set) var textField: UITextField?
    
    public static func currentDelegate(for object: UITextField) -> UITextFieldDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UITextFieldDelegate?, to object: UITextField) {
        object.delegate = delegate
    }
    
    /// - parameter textfield: Parent object for delegate proxy.
    public init(textField: ParentObject) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        register { RxTextFieldDelegateProxy(textField: $0)}
    }
    
    // MARK: delegate methods
    /// For more information take a look at `DelegateProxyType`.
    @objc open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return forwardToDelegate()?.textFieldShouldReturn?(textField) ?? true
    }
    
    @objc open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return forwardToDelegate()?.textFieldShouldClear?(textField) ?? true
    }
    
    @objc open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return forwardToDelegate()?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? false
    }
}
