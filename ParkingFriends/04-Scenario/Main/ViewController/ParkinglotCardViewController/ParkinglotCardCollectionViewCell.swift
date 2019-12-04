//
//  ParkinglotCardCollectionViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import TagListView

class ParkinglotCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var resevationButton: UIButton!
    @IBOutlet weak var tagListView: TagListView!
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        tagListView.textFont = Font.gothicNeoRegular14
    }
    
}
