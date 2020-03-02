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
    
    func tapReminderButton() -> Driver<()> 
}

class PaymentAgreementView: UIStackView, PaymentAgreementViewType {
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!

    var viewModel: PaymentAgreementViewModelType = PaymentAgreementViewModel()
    
    var disposeBag = DisposeBag()

    // MARK: - Public Methods
    
    public func getAgreementState() -> Observable<Bool> {
        return viewModel.agreementCheckState.asObservable()
    }
    
    public func tapReminderButton() -> Driver<()> {
        return reminderButton.rx.tap.asDriver()
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
        checkButton.rx.tap.asDriver()
            .map {
               return !self.checkButton.isSelected
            }
            .drive(self.checkButton.rx.isSelected)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    // MARK: - Life Cycle
    
    override func draw(_ rect: CGRect) {
    }
}
