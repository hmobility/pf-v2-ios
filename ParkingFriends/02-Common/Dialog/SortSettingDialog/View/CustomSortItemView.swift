//
//  CustomSortItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class CustomSortItemView: UIStackView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    var isSelected:Bool = false
    
    var itemValue:SortType = .distance
    
    // MARK: - Initializers
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // configure()
    }
    
    // MARK: - Public Methods
    
    public func selected(_ flag:Bool) {
        isSelected = flag
        markImageView.isHighlighted = flag
    }
    
    public func setItem(title:String, value:SortType, selected:Bool) {
        titleLabel.text = title
        markImageView.isHighlighted = selected
        itemValue = value
    }
    
    public func value() -> Observable<SortType> {
        return Observable.just(itemValue)
    }
    
    public func tapItem() -> Observable<UITapGestureRecognizer> {
        return backgroundView.rx.tapGesture().when(.recognized)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
