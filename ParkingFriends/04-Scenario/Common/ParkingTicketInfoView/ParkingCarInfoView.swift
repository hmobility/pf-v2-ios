//
//  ParkingCarInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/22.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingCarInfoViewType {
    func setInfo(number:String)
}

class CarInfoSectionView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
}

class CarInfoDisplayView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
}

class ParkingCarInfoView: UIStackView, ParkingCarInfoViewType {
    @IBOutlet weak var noCarInfoView: CarInfoSectionView!
    @IBOutlet weak var userCarInfoView: CarInfoSectionView!
    
    var carNumberText:BehaviorRelay<String?> = BehaviorRelay(value:nil)
    
    var viewModel:ParkingTicketInfoViewModelType = ParkingTicketInfoViewModel.shared
          
    var localizer:LocalizerType = Localizer.shared
    
    let disposeBag = DisposeBag()
     
    // MARK: - Binding
    
    private func setupNoCarInfoBinding() {
        viewModel.carInfoText
            .drive(noCarInfoView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.noCarInfoText
            .drive(noCarInfoView.carNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.addCarText
            .drive(noCarInfoView.addButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupCarInfoBinding() {
        viewModel.carInfoText
            .drive(userCarInfoView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.changeCarText
            .drive(userCarInfoView.changeButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupInfoBinding() {
        viewModel.getCarNumber()
            .subscribe(onNext: { [unowned self] carNumber in
                 self.setCarInfoSection(number: carNumber)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func setInfo(number:String) {
        viewModel.setCarNumber(number)
    }
    
    // MARK: - Local Methods
    
    func setCarInfoSection(number:String) {
        let noCarNumber = number.isEmpty ? true : false
        
        noCarInfoView.isHidden = noCarNumber ? false : true
        userCarInfoView.isHidden = noCarNumber ? true : false
        userCarInfoView.carNumberLabel.text = number
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupNoCarInfoBinding()
        setupCarInfoBinding()
        setupInfoBinding()
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
