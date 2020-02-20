//
//  ExtraCardTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MyCardNormalTableViewCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    private var localizer:LocalizerType = Localizer.shared
    
    private let disposeBag = DisposeBag()
     
    // MARK: - Initiailize
     
    func initialize(localizer: LocalizerType = Localizer.shared) {
        localizer.localized("btn_default_card_change")
            .drive(switchButton.rx.title())
            .disposed(by: disposeBag)
        
        localizer.localized("btn_remove")
            .drive(removeButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func configure(title:String, cardNumber:String) {
        cardNameLabel.text = title
        cardNumberLabel.text = cardNumber
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
