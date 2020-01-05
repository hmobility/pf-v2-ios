//
//  AddCarSectionView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

enum MenuCarSection {
    case add_new_car, change_my_car
}

class MenuCarSectionView: UIStackView {
    @IBOutlet var addNewCarView: UIView!
    @IBOutlet var addNewCarLabel: UILabel!
    @IBOutlet var addNewCarButton: UIButton!
    
    @IBOutlet var changeMyCarView: UIView!
    @IBOutlet var myCarLabel: UILabel!
    @IBOutlet var carListButton: UIButton!
    @IBOutlet var addCarButton: UIButton!
    
    private var sectionType:MenuCarSection = .add_new_car
    
    // MARK: - Public Methods
    
    public func setSectionType(_ type:MenuCarSection) {
        sectionType = type
    }
    
    public func setMyCarInfo(_ carInfo:String) {
        myCarLabel.text = carInfo
    }
    
    // MARK: - Local Methods
    
    private func udpateLayout() {
        if sectionType == .add_new_car {
            addNewCarView.isHidden = false
            changeMyCarView.isHidden = true
        } else {
            addNewCarView.isHidden = true
            changeMyCarView.isHidden = false
        }
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
         super.layoutSubviews()
         udpateLayout()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
