//
//  ParkingInfoItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkingInfoItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    var itemValue:ParkingInfoDialogType = .none
    
    public func setItem(title:String, value:ParkingInfoDialogType) {
        titleLabel.text = title
        itemValue = value
    }
    
    public func value() -> Observable<ParkingInfoDialogType> {
        return Observable.just(itemValue)
    }
    
    public func tapItem() -> Observable<ParkingInfoDialogType> {
        return self.rx.tapGesture().when(.recognized).asObservable().map {_ in
            return self.itemValue
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
