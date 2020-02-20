//
//  ParkingCCTVPlayerNavigatioView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkingCCTVPlayerNavigationView: UIStackView {
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var titleString: String?
    
    public func setTitle(_ title:String) {
        titleString = title
    }
    
    // MARK: - Life Cycle
       
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
