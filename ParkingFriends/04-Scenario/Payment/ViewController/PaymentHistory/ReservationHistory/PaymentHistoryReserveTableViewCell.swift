//
//  PaymentHistoryReserveTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/17.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class PaymentHistoryReserveTableViewCell: UITableViewCell {
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var placeTitleButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var carTitleButton: UIButton!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var productTypeButton: UIButton!
    
    // MARK: - Initialize
    
    private var priceUnitString:String?
    
    private var localizer:LocalizerType = Localizer.shared
    
    private let disposeBag = DisposeBag()
     
    // MARK: - Initiailize
     
    func initialize(localizer: LocalizerType = Localizer.shared) {
        priceUnitString = localizer.localized("txt_money_unit")
        
        localizer.localized("ttl_payment_history_place")
            .drive(placeTitleButton.rx.title())
            .disposed(by: disposeBag)
        
        localizer.localized("ttl_payment_history_car")
            .drive(carTitleButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func configure(title:String, price:Int, place:String, carNumber:String, productType:ProductType) {
        productTitleLabel.text = title
        priceLabel.text = "\(price.withComma)\(priceUnitString!)"
        placeLabel.text = place
        carNumberLabel.text = carNumber
        productTypeButton.titleLabel!.text = getProductTitle(with: productType)
    }
    
    // MARK: - Local Methods
    
    private func getProductTitle(with productType:ProductType) -> String {
        switch productType {
        case .time:
            return localizer.localized("ttl_ticket_time")
        case .fixed:
             return localizer.localized("ttl_ticket_fixed")
        case .monthly:
             return localizer.localized("ttl_ticket_monthly")
        }
    }

    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
