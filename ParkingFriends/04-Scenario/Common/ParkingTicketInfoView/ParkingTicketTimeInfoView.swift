//
//  ParkingTicketTimeInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/22.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingTicketTimeInfoViewType {
    func setInfo(date:String, time:String)
}

class ParkingTicketTimeInfoView: UIView, ParkingTicketTimeInfoViewType {
    @IBOutlet weak var reservationDateTitleLabel: UILabel!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var reservationTimeTitleLabel: UILabel!
    @IBOutlet weak var reservationTimeLabel: UILabel!
    
    var reservationDateText:BehaviorRelay<String> = BehaviorRelay(value:"")
    var reservationTimeText:BehaviorRelay<String> = BehaviorRelay(value:"")
    
    var viewModel:ParkingTicketInfoViewModelType = ParkingTicketInfoViewModel.shared
      
    var localizer:LocalizerType = Localizer.shared
    
    let disposeBag = DisposeBag()
     
    // MARK: - Public Methods
    
    public func setInfo(date:String, time:String) {
        reservationDateText.accept(date)
        reservationTimeText.accept(time)
    }
    
    // MARK: - Local Methods
    
    private func setupBinding() {
        viewModel.reservationDateText
            .drive(reservationDateTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.reservationTimeText
            .drive(reservationTimeTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTicketInfoBinding() {
        reservationDateText.asDriver()
            .drive(reservationDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reservationTimeText.asDriver()
            .drive(reservationTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
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
