//
//  ParkinglotNearbyTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import TagListView

class ParkingDistanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceUnitLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    // MARK: - Initialize

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public Methods
    
    public func configure(_ element:WithinElement, unit:String = Localizer.shared.localized("txt_distance_unit"), tags:[String]) {
        titleLabel.text = element.name
        addressLabel.text = element.address
        distanceLabel.text = element.distance.withComma
        distanceUnitLabel.text = unit
        tagListView.addTags(tags)
    }
}
