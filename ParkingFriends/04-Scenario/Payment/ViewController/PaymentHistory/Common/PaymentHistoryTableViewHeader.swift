//
//  PaymentHistoryTableViewHeader.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class PaymentHistoryTableViewHeader: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    private var titleString:String?
    
    // MARK: - Public Methods
    
    public func setTitle(_ title:String) {
        titleString = title
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        titleLabel.text = titleString
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
