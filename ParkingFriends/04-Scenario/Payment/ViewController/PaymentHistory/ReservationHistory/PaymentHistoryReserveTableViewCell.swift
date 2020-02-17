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
    
    private var localizer:LocalizerType = Localizer.shared
    
    private let disposeBag = DisposeBag()
     
     // MARK: - Initiailize
     
    func initialize(localizer: LocalizerType = Localizer.shared) {
        localizer.localized("ttl_payment_history_place")
            .drive(carTitleButton.rx.title())
            .disposed(by: disposeBag)
        
        localizer.localized("ttl_payment_history_place")
                  .drive(carTitleButton.rx.title())
                  .disposed(by: disposeBag)
    }

    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
