//
//  ExtraCardTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ExtraCardTableViewCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
