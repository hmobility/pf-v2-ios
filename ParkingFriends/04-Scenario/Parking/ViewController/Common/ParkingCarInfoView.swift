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

class ParkingCarInfoView: UIView, ParkingCarInfoViewType {
    @IBOutlet weak var carInfoTitleLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
    
    private var localizer:LocalizerType = Localizer.shared
    
    private var carNumberText:BehaviorRelay<String> = BehaviorRelay(value:"")
    
    let disposeBag = DisposeBag()
     
    // MARK: - Public Methods
    
    public func setInfo(number:String) {
        carNumberText.accept(number)
    }
    
    // MARK: - Local Methods
    
    private func setupInfoBinding() {
        carNumberText.asDriver()
            .drive(carNumberLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        carInfoTitleLabel.text = localizer.localized("ttl_car_info")

        setupInfoBinding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
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
