//
//  ParkinglotDistanceTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import TagListView

class ParkingPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceUnitLabel: UILabel!
    @IBOutlet weak var unitTextLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    // MARK: - Initialize
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public Methods
    
    public func configure(_ element:WithinElement, unit:String = Localizer.shared.localized("txt_money_unit"), perUnit:String = Localizer.shared.localized("txt_hours"), tags:[String]) {
        titleLabel.text = element.name
        addressLabel.text = element.address
        priceLabel.text = element.price.withComma
        priceUnitLabel.text = unit
        unitTextLabel.text = "/\(perUnit)"
        tagListView.addTags(tags)
    }

}
