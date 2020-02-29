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
              //  self.setPointSection(with: points)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func setUserPoints(_ points:Int) {
        viewModel.setUserPoints(points)
    }
    
    // MARK: - Local Methods
    
    func setPointsSection(with points:Int) {
      //  noPointsView
       // pointsInputView.set
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
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
