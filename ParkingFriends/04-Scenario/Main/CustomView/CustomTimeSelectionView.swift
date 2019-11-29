//
//  CustomTimeSelectionView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class CustomTimeSelectionView: UIView {
    @IBOutlet var stackView:UIStackView!
    @IBOutlet var searchView:UIView!
    @IBOutlet var searchTextLabel:UILabel!
    @IBOutlet var timeSelectionLabel:UILabel!
    @IBOutlet var timeSelectionView:UIView!
    
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
    
    public func setTime(time:String) {
        timeSelectionLabel.text = time
    }
    
    public func tapSelectTime() -> Observable<UITapGestureRecognizer> {
        return timeSelectionView.rx.tapGesture().when(.recognized)
    }
    
    public func tapSearchArea() -> Observable<UITapGestureRecognizer> {
        return searchView.rx.tapGesture().when(.recognized)
    }
    
    // MARK: - Drawings
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
