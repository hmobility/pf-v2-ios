//
//  FixedMarkView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

enum MarkerType {
    case main
    case disabled
    case normal
}

protocol PriceMarkerType {
    func price(_ price:Int, type:MarkerType)
}

class FixedMarkView: UIView, PriceMarkerType {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    func price(_ price: Int, type: MarkerType) {
        priceLabel.text = price.withComma
        
        switch type {
        case .main:
            backgroundImageView.image = UIImage(named:"imgMainMarker")!
        case .disabled:
            backgroundImageView.image = UIImage(named:"imgDisabledMarker")!
        case .normal:
            backgroundImageView.image = UIImage(named:"imgNormalMarker")!
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
