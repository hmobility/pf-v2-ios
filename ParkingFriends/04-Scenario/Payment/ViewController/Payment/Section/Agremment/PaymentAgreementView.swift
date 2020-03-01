//
//  PaymentTotalPriceView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/30.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol PaymentAgreementViewType {
    func getAgreementState() -> Observable<Bool>
}

class PaymentAgreementView: UIStackView, PaymentAgreementViewType {
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    var viewModel: PaymentAgreementViewModelType = PaymentAgreementViewModel()
    
    let disposeBag = DisposeBag()

    // MARK: - Public Methods
    
    public func getAgreementState() -> Observable<Bool> {
        return viewModel.agreementCheckState.asObservable()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        viewModel.agreementGuideText
             .drive(guideLabel.rx.text)
             .disposed(by: disposeBag)
        
        viewModel.agreementText
            .asObservable()
            .map { return self.getAttributedString(with: $0) }
            .bind(to: reminderButton.rx.attributedTitle())
            .disposed(by: disposeBag)
    }
    
    func setupButtonBinding() {
        checkButton.rx.tap
            .asObservable()
            .map { return !self.checkButton.isSelected }
            .map { selected in
                self.checkButton.isSelected = selected
                return selected
            }
            .bind(to: viewModel.agreementCheckState)
            .disposed(by: disposeBag)
    }
    
    func getAttributedString(with text:String) -> NSMutableAttributedString {
          return NSMutableAttributedString(string: text,
          attributes:[NSAttributedString.Key.foregroundColor: Color.steel,
                      NSAttributedString.Key.font: Font.gothicNeoRegular14,
                      NSAttributedString.Key.underlineStyle:1.0])
      }
    
    // MARK: - Initialize
    
    func initialize() {
        setupBinding()
        setupButtonBinding()
    }
    
    // MARK: - Life Cycle
    
    override func draw(_ rect: CGRect) {
        initialize()
    }
}
