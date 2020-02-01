//
//  ParkinglotDetailEditTimeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class TimeButtonView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    public func setTitle(_ title:String) {
        titleLabel.text = title
    }
    
    public func setScheduledTime(_ text:String) {
        descLabel.text = text
    }
}

class ParkinglotDetailEditTimeView: UIStackView {
    @IBOutlet weak var changeButtonView: TimeButtonView!
    @IBOutlet weak var timeEditingContolView: UIStackView!
    
    @IBOutlet weak var changeTimeView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    private var viewModel: ParkinglotDetailEditTimeViewModelType = ParkinglotDetailEditTimeViewModel()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
        setEditingMode(false, animated: false)
        setupTitleBinding()
       // setupBinding()
        setupButtonBinding()
    }
      
    // MARK: - Binding
    
    private func setupTitleBinding() {
        viewModel.changeButtonTitleText
            .asDriver()
            .drive(changeButtonView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.viewTitleText
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupBinding() {
        viewModel.changeButtonTitleText
            .asDriver()
            .drive(changeButtonView.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        changeButtonView.rx
                .tapGesture()
                .when(.recognized)
                .subscribe { _ in
                    self.setEditingMode(true)
                }
                .disposed(by: disposeBag)
    
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
        
        applyButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func setEditingMode(_ editing:Bool, animated:Bool = true) {
       self.changeTimeView.isHidden = editing ? true : false
        
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .curveEaseInOut, animations: {
                self.timeEditingContolView.isHidden = editing ? false : true
            })
        } else {
            self.timeEditingContolView.isHidden = editing ? false : true
        }
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
