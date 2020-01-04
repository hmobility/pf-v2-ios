/*
 MIT License
 
 Copyright (c) RxSwiftCommunity
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import RxSwift
import RxCocoa
import UIKit

struct alert_button_color {
    static let cancel = #colorLiteral(red: 0.8078431373, green: 0.8196078431, blue: 0.831372549, alpha: 1)
    static let normal = #colorLiteral(red: 0.2078431373, green: 0.2352941176, blue: 0.2666666667, alpha: 1)
    static let title = Color.darkGrey
    static let message = Color.charcoalGrey
}

struct alert_font {
    static let title = Font.gothicNeoMedium15
    static let message = Font.gothicNeoRegular15
}

// MARK: - UIAlertController
extension UIAlertController {
    
    public func addAction(actions: [AlertAction]) -> Observable<Int> {
        return Observable.create { [weak self] observer in
            actions.map { action in
                return UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action.type)
                    observer.onCompleted()
                }
                }.forEach { action in
                    let color = (action.style == .cancel) ? alert_button_color.cancel : alert_button_color.normal
                    action.setValue(color, forKey: "titleTextColor")
                    self?.addAction(action)
            }
            
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController {
    public func alert(title: String?,
               message: String? = nil,
               actions: [AlertAction],
               preferredStyle:UIAlertController.Style = .alert) -> Observable<Int> {
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let firstSubView = actionSheet.view.subviews.first
        let alertContentView = firstSubView?.subviews.first
        
        if let title = actionSheet.title {
            actionSheet.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : alert_font.title, NSAttributedString.Key.foregroundColor : alert_button_color.title]), forKey: "attributedTitle")
        }
            
        if let message = actionSheet.message {
            actionSheet.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : alert_font.message, NSAttributedString.Key.foregroundColor : alert_button_color.message]), forKey: "attributedMessage")
        }
        
        for subview in (alertContentView?.subviews)! {
            subview.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            subview.layer.cornerRadius = 4
            subview.alpha = 1
            subview.layer.borderWidth = 0.5
            subview.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        }
        
        return actionSheet.addAction(actions: actions)
            .do(onSubscribed: {
                self.present(actionSheet, animated: true, completion: nil)
            }).observeOn(MainScheduler.instance)
    }
}
