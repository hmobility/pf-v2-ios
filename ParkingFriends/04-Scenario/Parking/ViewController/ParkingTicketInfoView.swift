//
//  ParkingTicketInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkingTicketInfoView: UIStackView {
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var parkinglotTitleField: UILabel!
    @IBOutlet weak var parkinglotTitle: UILabel!
    
    @IBOutlet weak var productTitleField: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    
    
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}

class TimeTicketSectionView: UIView {
    @IBOutlet weak var bookingDateTitleField: UILabel!
    @IBOutlet weak var bookingDateTitle: UILabel!
    @IBOutlet weak var bookingTimeTitleField: UILabel!
    @IBOutlet weak var bookingTimeTitle: UILabel!
}

class MonthlyTicketSectionView: UIView {
    @IBOutlet weak var bookingDateTitleField: UILabel!
    @IBOutlet weak var bookingDateTitle: UILabel!
    @IBOutlet weak var bookingTimeTitleField: UILabel!
    @IBOutlet weak var bookingTimeTitle: UILabel!
}

class FixedTicketSectionView: UIView {
    @IBOutlet weak var bookingTimeTitleField: UILabel!
    @IBOutlet weak var bookingTimeTitle: UILabel!
}

class CarInfoSectionView: UIView {
}
