//
//  ParkinglotDetailOperatingTimeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/18.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class OperationTimeItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
}

class ParkinglotDetailOperationTimeView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weekdayView: OperationTimeItemView!
    @IBOutlet weak var weekendView: OperationTimeItemView!
    @IBOutlet weak var holidayView: OperationTimeItemView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
