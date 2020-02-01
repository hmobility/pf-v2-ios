//
//  ParkinglotDetailButtonView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailButtonView: UIStackView {
    @IBOutlet weak var reserveDisabledButton: UIButton!
    @IBOutlet weak var reserveButtonArea: UIStackView!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var reserveButton: UIButton!
    
    private var viewModel: ParkinglotDetailButtonViewModelType = ParkinglotDetailButtonViewModel()

    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType = Localizer.shared
    
    var giftButtonAction: ((_ flag:Bool) -> Void)?
    var reserveButtonAction: ((_ flag:Bool) -> Void)?
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
        setupButtonBinding()
    }
    
    // MARK: - Public Methods
    
    public func getViewModel() -> ParkinglotDetailButtonViewModel? {
        return (viewModel as! ParkinglotDetailButtonViewModel)
    }
    
    public func setBookableState(_ enabled:Bool) {
        if enabled {
            reserveButtonArea.isHidden = false
            reserveDisabledButton.isHidden = true
        } else {
            reserveButtonArea.isHidden = true
            reserveDisabledButton.isHidden = false
        }
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.disabledReserveButtonText
            .asDriver()
            .drive(self.reserveDisabledButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.giftButtonText
            .asDriver()
            .drive(self.giftButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.reserveButtonText
            .asDriver()
            .drive(self.reserveButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        viewModel.bookableState
            .asDriver()
            .drive(onNext:{ enabled in
                self.setBookableState(enabled)
            })
            .disposed(by: disposeBag)
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        initialize()
    }
}
