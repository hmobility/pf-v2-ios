//
//  ParkingTicketTimeInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/22.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingTicketMonthlyInfoViewType {
    func setInfo(start:String, end:String)
}

class ParkingTicketMonthlyInfoView: UIView, ParkingTicketMonthlyInfoViewType {
    @IBOutlet weak var reservationDateStartTitleLabel: UILabel!
    @IBOutlet weak var reservationDateStartLabel: UILabel!
    @IBOutlet weak var reservationDateEndTitleLabel: UILabel!
    @IBOutlet weak var reservationDateEndLabel: UILabel!
    
    var reservationDateStartText:BehaviorRelay<String> = BehaviorRelay(value:"")
    var reservationDateEndText:BehaviorRelay<String> = BehaviorRelay(value:"")
    
    var viewModel:ParkingTicketInfoViewModelType = ParkingTicketInfoViewModel.shared
       
    var localizer:LocalizerType = Localizer.shared
    
    let disposeBag = DisposeBag()
     
    // MARK: - Public Methods
    
    public func setInfo(start:String, end:String) {
        reservationDateStartText.accept(start)
        reservationDateEndText.accept(end)
    }
    
    // MARK: - Local Methods
    
    private func setupBinding() {
        viewModel.reservationDateStartText
            .drive(reservationDateStartTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.reservationDateEndText
            .drive(reservationDateEndTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setupTicketInfoBinding() {
        reservationDateStartText.asDriver()
             .drive(reservationDateStartLabel.rx.text)
             .disposed(by: disposeBag)
        
        reservationDateEndText.asDriver()
            .drive(reservationDateEndLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    func initialize() {
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
