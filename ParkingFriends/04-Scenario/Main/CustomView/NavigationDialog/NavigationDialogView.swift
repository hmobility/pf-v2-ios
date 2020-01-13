//
//  NavigationDialogView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/12.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class NavigationDialogView: UIView {
    @IBOutlet var mainTitleLabel:UILabel!
    @IBOutlet var subTitleLabel:UILabel!
    @IBOutlet var menuButton:UIButton!
    @IBOutlet var searchOptionButton:UIButton!
    
    // MARK: - Public Methods
    
    public func setReservable(time:String) {
        subTitleLabel.text = time
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
