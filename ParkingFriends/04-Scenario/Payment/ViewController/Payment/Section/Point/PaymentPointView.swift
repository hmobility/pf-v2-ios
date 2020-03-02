//
//  PaymentPointView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/30.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol PaymentPointViewType {
    func setUserPoints(_ points:Int)
    func getPointsToUse() -> Int
}

class PaymentPointView: UIStackView, PaymentPointViewType {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noPointsView: PaymentNoPointsSectionView!
    @IBOutlet weak var pointsInputView: PaymentPointsInputSectionView!
    
    var viewModel: PaymentPointViewModelType = PaymentPointViewModel()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    func setupBinding() {
        viewModel.viewTitleText
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.getUserPoints()
            .subscribe(onNext: { [unowned self] points in
                self.setPointsSection(with: points)
            })
            .disposed(by: disposeBag)
    }
    
    func setupNoPointsBinding() {
        viewModel.userPointsText
            .drive(noPointsView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.noPointsText
            .drive(noPointsView.subtitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setupUserPointsBinding() {
        viewModel.userPointsFieldText
            .drive(pointsInputView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pointsInputPlaceholder
            .drive(pointsInputView.pointsInputField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.pointsToUseLimitText
            .drive(pointsInputView.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userPointsText
            .drive(pointsInputView.userPointsTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.useAllPointsText
            .asObservable()
            .map { return self.getAttributedString(with: $0) }
            .bind(to: pointsInputView.useAllPointsButton.rx.attributedTitle())
            .disposed(by: disposeBag)
    }
    
    func setupButtonBinding() {
        pointsInputView.useAllPointsButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                let points = self.viewModel.getAllPoints()
                self.pointsInputView.setInputPoints(with: points)
            })
            .disposed(by: disposeBag)
    }
    
    func getAttributedString(with text:String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
        attributes:[NSAttributedString.Key.foregroundColor: Color.slateGrey,
                    NSAttributedString.Key.font: Font.gothicNeoRegular15,
                    NSAttributedString.Key.underlineStyle:1.0])
    }
  
    // MARK: - Public Methods
    
    public func getPointsToUse() -> Int {
        return pointsInputView.getInputPointsToUse()
    }
    
    public func setUserPoints(_ points:Int) {
        viewModel.setUserPoints(points)
    }
    
    // MARK: - Local Methods
    
    func setPointsSection(with points:Int?) {
        if let userPoints = points {
            self.isHidden = false
            let noPoints = userPoints > 0 ? false : true
            pointsInputView.setUserPoints(with: userPoints)
            noPointsView.isHidden = noPoints ? false : true
            pointsInputView.isHidden = noPoints ? true : false
        } else {
            self.isHidden = true
        }
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
        setupNoPointsBinding()
        setupUserPointsBinding()
        setupButtonBinding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
    }

}
