//
//  TimeButtonView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/11.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailScheduleButtonView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    public func setTitle(_ title:String) {
        titleLabel.text = title
    }
    
    public func setScheduledTime(_ text:String) {
        descLabel.text = text
    }
}
