//
//  UITextField+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

@IBDesignable
extension UITextField {
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    @IBInspectable var cursorColor: UIColor {
        get {
            return self.tintColor
        }
        set {
            self.tintColor = newValue
        }
    }
    
    // TextField Delegate
    
    func setCursorLocation(_ location: Int) {
        if let cursorLocation = position(from: beginningOfDocument, offset: location) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.selectedTextRange = strongSelf.textRange(from: cursorLocation, to: cursorLocation)
            }
        }
    }
}

// MARK: - TextField Accessory - Done

@IBDesignable
extension UITextField {
      @IBInspectable var doneAccessory: Bool {
          get {
              return self.doneAccessory
          }
          set (hasDone) {
              if hasDone{
                  addDoneButtonOnKeyboard()
              }
          }
      }
      
      func addDoneButtonOnKeyboard(title: String = Localizer.shared.localized("btn_close"), textColor: UIColor = UIColor.black) {
          let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
          doneToolbar.barStyle = .default
          
          let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let done: UIBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(self.doneButtonAction))
          done.tintColor = textColor
          
          let items = [flexSpace, done]
          doneToolbar.items = items
          doneToolbar.sizeToFit()
          
          self.inputAccessoryView = doneToolbar
      }
      
      @objc func doneButtonAction() {
          self.resignFirstResponder()
      }
}
