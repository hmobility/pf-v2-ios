//
//  ParkinglotDetailPriceItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailPriceItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    public func setTimeTicket(title:String? = nil, price: String) {
        if let titleString = title {
            titleLabel.text = titleString
        }
        
        priceLabel.text = price
    }
    
    public func setFixedTicket(title:String, price: String) {
        titleLabel.text = title
        priceLabel.text = price
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
