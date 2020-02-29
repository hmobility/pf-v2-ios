//
//  ParkinglotDetailMonthlyTicketPriceItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailMonthlyTicketPriceItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var priceLabel: [UILabel]!
    
    public func setMonthlyTicket(title:String? = nil, price: String, index:Int) {
        if let titleString = title {
            titleLabel.text = titleString
        }
        
        if index < priceLabel.count {
            priceLabel[index].text = price
        }
    }
}
