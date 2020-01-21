//
//  ParkinglotDetailReserveView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailReserveView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var availableParkinglotLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    
    // MARK: - Initializer

    private func initialize() {
        setupBinding()
        setupButtonBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        localizer.localized("ttl_detail_real_time_reserve_state")
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("txt_detail_real_time_available_lots")
            .asDriver()
            .drive(self.availableParkinglotLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        infoButton.rx.tap
            .subscribe(onNext: { [unowned self] status in
                self.navigateToGuide()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - Navigation
    
    private func navigateToGuide() {
        let target = Storyboard.detail.instantiateViewController(withIdentifier: "TimeLabelGuideViewController") as! TimeLabelGuideViewController
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .forever
        config.presentationStyle = .center
        config.preferredStatusBarStyle = .lightContent
   
        SwiftMessages.show(config: config, view: target.view)
    }
}
