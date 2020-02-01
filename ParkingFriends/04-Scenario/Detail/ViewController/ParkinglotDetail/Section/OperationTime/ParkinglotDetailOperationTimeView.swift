//
//  ParkinglotDetailOperationgTimeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailOperationgTimeItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    private var localizer:LocalizerType = Localizer.shared

    private let disposeBag = DisposeBag()
    
    public func setOperationTime(with time:String) {
        descLabel.text = time
    }
}

class ParkinglotDetailOperationTimeView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weekdayView: ParkinglotDetailOperationgTimeItemView!
    @IBOutlet weak var saturdayView: ParkinglotDetailOperationgTimeItemView!
    @IBOutlet weak var sundayView: ParkinglotDetailOperationgTimeItemView!
    @IBOutlet weak var holidayView: ParkinglotDetailOperationgTimeItemView!
    
    private var viewModel: ParkinglotDetailOperationTimeViewModelType = ParkinglotDetailOperationTimeViewModel()
  
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Initializer

    private func initialize() {
        setupTitleBinding()
        setupInitTimeBinding()
        setupBinding()
        setupTimeBinding()
    }
    
    // MARK: - Public Methods
    
    public func getViewModel() -> ParkinglotDetailOperationTimeViewModel? {
        return (viewModel as! ParkinglotDetailOperationTimeViewModel)
    }

    // MARK: - Binding
    
    private func setupTitleBinding() {
        viewModel.viewTitleText
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupInitTimeBinding() {
        viewModel.closedStateText
            .asDriver()
            .drive(self.weekdayView.descLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.closedStateText
              .asDriver()
              .drive(self.saturdayView.descLabel.rx.text)
              .disposed(by: disposeBag)
          
        viewModel.closedStateText
              .asDriver()
              .drive(self.sundayView.descLabel.rx.text)
              .disposed(by: disposeBag)
        
        viewModel.closedStateText
            .asDriver()
            .drive(self.holidayView.descLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupBinding() {
        viewModel.weekdayFieldText
            .asDriver()
            .drive(self.weekdayView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.saturdayFieldText
            .asDriver()
            .drive(self.saturdayView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.sundayFieldText
              .asDriver()
              .drive(self.sundayView.titleLabel.rx.text)
              .disposed(by: disposeBag)
        
        viewModel.holidayFieldText
            .asDriver()
            .drive(self.holidayView.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTimeBinding() {
        viewModel.getOperationTimeList()
            .subscribe(onNext: { (operationType, timeString) in
                switch operationType {
                case .holiday:
                    self.holidayView.setOperationTime(with: timeString)
                case .weekday:
                    self.weekdayView.setOperationTime(with: timeString)
                case .sunday:
                    self.sundayView.setOperationTime(with: timeString)
                case .saturday:
                    self.saturdayView.setOperationTime(with: timeString)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        initialize()
    }
}
