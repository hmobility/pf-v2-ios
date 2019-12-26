//
//  GroupMarkerView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/23.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class GroupMarkerView: UIView {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var circleBackground: UIView!
    @IBOutlet weak var districtBackground: UIView!
    
    // MARK - Public Methods
    
    public func count(_ count: Int, district: String) {
        countLabel.text = count.withComma
        districtLabel.text = district
        districtLabel.sizeToFit()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
