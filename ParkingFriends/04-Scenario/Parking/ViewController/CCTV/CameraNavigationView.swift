//
//  ParkingCCTVPlayerNavigatioView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol CameraNavigationViewType {
    func setTitle(_ title:String)
}

class CameraNavigationView: UIStackView, CameraNavigationViewType {
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleText:BehaviorRelay = BehaviorRelay(value:"")
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setTitle(_ title:String) {
        titleText.accept(title)
    }

    // MARK: - Binding
    
    func setupBinding() {
        titleText.asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    func initialize() {
        setupBinding()
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
