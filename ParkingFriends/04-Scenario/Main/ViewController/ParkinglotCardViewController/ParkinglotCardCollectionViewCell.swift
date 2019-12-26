//
//  ParkinglotCardCollectionViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import TagListView

class ParkinglotCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var resevationButton: UIButton!
    @IBOutlet weak var tagListView: TagListView!
    
    private lazy var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        tagListView.textFont = Font.gothicNeoRegular14
    }
    
    // MARK: - Binding
    
    // MARK: - Public Methods
 
    public func setTagList(_ tags:[String]) {
        tagListView.addTags(tags)
    }
    
    public func setTitle(_ title:String, distance:Int) {
        let distanceUnit = localizer.localized("txt_distance_unit") as String
        titleLabel.text = title
        distanceLabel.text = "\(distance.withComma)\(distanceUnit)"
    }
    
    public func setPrice(_ price:Int) {
        let moneyUnit = localizer.localized("txt_money_unit") as String
        let hourTxt = localizer.localized("txt_hours") as String
        priceLabel.text = price.withComma
        unitLabel.text = "\(moneyUnit)/\(hourTxt)"
    }
}
