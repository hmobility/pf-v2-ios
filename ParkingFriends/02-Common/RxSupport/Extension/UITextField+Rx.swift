//
//  Reactive+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/10.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

extension Reactive where Base: UITextField {
    public var placeholder: Binder<String?> {
        return Binder(self.base) { textfield, text in
            textfield.placeholder = text
        }
    }
}

extension Reactive where Base: UITextField {

    public var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
          return RxTextFieldDelegateProxy.proxy(for: base)
    }

    /// Reactive wrapper for `delegate` message.
    
    public var shouldReturn: ControlEvent<Void> {
        let source = delegate.rx.methodInvoked(#selector(UITextFieldDelegate.textFieldShouldReturn))
            .map { _ in }
        
        return ControlEvent(events: source)
    }
    
    public var shouldClear: ControlEvent<Void> {
        let source = delegate.rx.methodInvoked(#selector(UITextFieldDelegate.textFieldShouldClear))
            .map { _ in }

        return ControlEvent(events: source)
    }
    
    public var shouldChangeCharactersIn: Observable<(UITextField, NSRange, String)> {
        return delegate.rx.methodInvoked(#selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:)))
            .map { params in
               return (params[0] as! UITextField, params[1] as! NSRange, params[2] as! String)
        }
    }
}
