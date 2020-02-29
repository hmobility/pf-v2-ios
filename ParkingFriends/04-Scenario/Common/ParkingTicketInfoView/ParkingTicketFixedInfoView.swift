//
//  ParkingTicketTimeInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/22.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingTicketFixedInfoViewType {
    func setInfo(time:String)
}

class ParkingTicketFixedInfoView: UIView, ParkingTicketFixedInfoViewType {
    @IBOutlet weak var reservationTimeTitleLabel: UILabel!
    @IBOutlet weak var reservationTimeLabel: UILabel!
    
    var reservationTimeText:BehaviorRelay<String> = BehaviorRelay(value:"")
    
    var localizer:LocalizerType = Localizer.shared
    
    let disposeBag = DisposeBag()
     
    // MARK: - Public Methods
    
    public func setInfo(time:String) {
        reservationTimeText.accept(time)
    }
    
    // MARK: - Local Methods
    
    private func setupTicketInfoBinding() {
        reservationTimeText.asDriver()
                   .drive(reservationTimeLabel.rx.text)
                   .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        reservationTimeTitleLabel.text = localizer.localized("ttl_reservation_time")
        
        setupTicketInfoBinding()
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
