//
//  ParkingTicketBasicInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/22.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingTicketBasicInfoViewType {
    func setInfo(name:String, product:String, date:String)
}

class ParkingTicketBasicInfoView: UIView, ParkingTicketBasicInfoViewType {
    @IBOutlet weak var parkinglotNameTitleLabel: UILabel!
    @IBOutlet weak var parkinglotNameLabel: UILabel!
    @IBOutlet weak var productNameTitleLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var paymentDateTitleLabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    
    var parkinglotNameText:BehaviorRelay<String> = BehaviorRelay(value:"")
    var productNameText:BehaviorRelay<String> = BehaviorRelay(value:"")
    var paymentDateText:BehaviorRelay<String> = BehaviorRelay(value:"")
    
    var localizer:LocalizerType = Localizer.shared
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setInfo(name:String, product:String, date:String) {
        parkinglotNameText.accept(name)
        productNameText.accept(product)
        paymentDateText.accept(date)
    }
    
    // MARK: - Local Methods
    
    private func setupTicketInfoBinding() {
        parkinglotNameText.asDriver()
            .drive(parkinglotNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        productNameText.asDriver()
            .drive(productNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        paymentDateText.asDriver()
            .drive(paymentDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
     
    // MARK: - Initialize
    
    private func initialize(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        parkinglotNameTitleLabel.text = localizer.localized("ttl_parkinglot_name")
        productNameTitleLabel.text = localizer.localized("ttl_product_purchased")
        paymentDateTitleLabel.text = localizer.localized("ttl_payment_date")
        
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
