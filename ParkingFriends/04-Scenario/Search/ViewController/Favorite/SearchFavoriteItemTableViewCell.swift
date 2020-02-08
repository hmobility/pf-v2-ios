//
//  SearchFavoriteItemTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class SearchFavoriteItemTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Public Methods
    
    public func setTitle(with title:String) {
        titleLabel.text = title
    }
    
    // MARKL: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
