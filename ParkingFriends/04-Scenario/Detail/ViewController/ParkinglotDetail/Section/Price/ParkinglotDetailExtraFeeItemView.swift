//
//  ParkinglotDetailExtraFeeItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailExtraFeeItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    public func setGuideText(_ text: String) {
        titleLabel.text = text
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
