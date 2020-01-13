//
//  CustomTimeSelectionView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class CustomTimeSettingView: UIView {
    @IBOutlet var stackView:UIStackView!
    @IBOutlet var searchView:UIView!
    @IBOutlet var searchTextLabel:UILabel!
    @IBOutlet var timeSettingLabel:UILabel!
    @IBOutlet var timeSettingView:UIView!
    
    // MARK: - Initializers
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: - Local Methods
    
    // MARK: - Public Methods
    
    public func setReservable(time:String) {
        timeSettingLabel.text = time
    }
    
    public func tapSelectTime() -> Observable<UITapGestureRecognizer> {
        return timeSettingView.rx.tapGesture().when(.recognized)
    }
    
    public func tapSearchArea() -> Observable<UITapGestureRecognizer> {
        return searchView.rx.tapGesture().when(.recognized)
    }
    
    // MARK: - Drawings
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
