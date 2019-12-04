//
//  FixedMarkView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

protocol PriceMarkerType {
    func price(_ price:Int, enabled:Bool)
}

class FixedMarkView: UIView, PriceMarkerType {

    @IBOutlet weak var priceLabel: UILabel!
    
    func price(_ price: Int, enabled: Bool) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
