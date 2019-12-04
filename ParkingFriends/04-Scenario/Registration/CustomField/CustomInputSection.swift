//
//  CustomInputSection.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@IBDesignable
class CustomInputSection: UIStackView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var fieldTitleLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var displayTextLabel: UILabel!            // Fixed Text instead of inputTextField
    @IBOutlet var messageLabel: UILabel!

    @IBInspectable var normalColor: UIColor?
    @IBInspectable var focusedColor: UIColor?

    @IBInspectable var cursorColor: UIColor?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // configure()
    }
    
    // MARK: - Private Methdos
    
    private func inputFieldBinding() {
        guard let inputField = self.inputTextField else {
            return
        }
        
        inputField.rx.controlEvent([.editingDidBegin, .editingChanged, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] result in
                self.setNeedsDisplay()
            }).disposed(by: disposeBag)
        
        if let color = cursorColor {
            inputTextField.tintColor = color
        }
    }
      
    // MARK: - Drawings
    
    override func layoutSubviews() {
        super.layoutSubviews()
        inputFieldBinding()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        customDraw()
    }
    
    private func customDraw() {
        guard let inputField = self.inputTextField else {
            return
        }
        
        if inputField.isEditing || inputField.isFocused {
            backgroundView.borderColor = focusedColor
            fieldTitleLabel.textColor = focusedColor
        } else {
            backgroundView.borderColor = normalColor
            
            if inputField.text!.isEmpty {
                fieldTitleLabel.textColor = normalColor
            } else {
                fieldTitleLabel.textColor = focusedColor
            }
        }
    }
}
