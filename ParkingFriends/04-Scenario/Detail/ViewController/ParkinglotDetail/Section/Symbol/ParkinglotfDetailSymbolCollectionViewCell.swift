//
//  ParkinglotTagCollectionViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/09.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotfDetailSymbolCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Public Methods
    
    public func setTitle(_ title:String, image:UIImage) {
        titleLabel.text = title
        iconImageView.image = image
    }
}
