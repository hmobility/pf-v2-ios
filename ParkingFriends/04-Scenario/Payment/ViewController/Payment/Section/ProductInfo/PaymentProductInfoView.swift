//
//  PaymentProductInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/30.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class PaymentProductInfoView: UIStackView {
    @IBOutlet weak var basicInfoView: PaymentProductBasicInfoView!
    @IBOutlet weak var productTimeView: PaymentProductInfoTimeView!
    @IBOutlet weak var productFixedView: PaymentProductInfoFixedView!
    @IBOutlet weak var productMonthlyView: PaymentProductInfoMonthlyView!
    @IBOutlet weak var registeredCarInfoView: PaymentProductInfoCarView!
    @IBOutlet weak var noRegisteredCarInfoView: PaymentProductInfoCarView!
    
    
    // MARK: - Initializers
      
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout Life Cycle

    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}
