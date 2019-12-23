//
//  FixedMarkView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

enum MarkerType {
    case normal
    case disabled
    case green
    case partner
}

class MarkerView: UIView {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    public func price(_ price: Int, type: MarkerType) {
        priceLabel.text = price.withComma
        
        switch type {
        case .normal:
            backgroundImageView.image = UIImage(named:"imgMarkerNormal")!
        case .disabled:
            backgroundImageView.image = UIImage(named:"imgMarkerDisabled")!
        case .green:
            backgroundImageView.image = UIImage(named:"imgMarkerGreen")!
        case .partner:
            backgroundImageView.image = UIImage(named:"imgMarkerPartner")!
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
