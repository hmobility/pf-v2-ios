//
//  LevelGuideTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class LevelGuideTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var benefitLabel: UILabel!
    
    // MARK: - Public Methods
    
    public func configure(level:PointLevelType, title:String, desc:String, benefit:String) {
        let image = getLevelImage(level)
        iconImageView.image = image
        titleLabel.text = title
        descriptionLabel.text = desc
        benefitLabel.text = benefit
    }
    
    // MARK: - Local Methods
    
    private func getLevelImage(_ level:PointLevelType) -> UIImage {
        let index = level.rawValue
        return UIImage(named: "imgBadgeUsergradeSmall\(index)")!
    }
    
    // MARK: - Initialize
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
