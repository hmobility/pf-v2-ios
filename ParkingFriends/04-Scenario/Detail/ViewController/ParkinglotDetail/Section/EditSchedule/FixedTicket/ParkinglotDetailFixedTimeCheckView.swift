//
//  ParkinglotDetailTimeCheckView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/11.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailFixedTimeCheckView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    public func setTitle(_ title:String) {
        titleLabel.text = title
    }
}
