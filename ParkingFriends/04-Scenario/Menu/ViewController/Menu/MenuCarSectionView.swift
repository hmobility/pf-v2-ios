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

protocol MenuCarSectionViewType {
    func setMyCarInfo(_ carInfo:String)
}

class MenuCarSectionView: UIStackView, MenuCarSectionViewType {
    @IBOutlet var addNewCarView: UIView!
    @IBOutlet var addNewCarLabel: UILabel!
    @IBOutlet var addNewCarButton: UIButton!
    
    @IBOutlet var changeMyCarView: UIView!
    @IBOutlet var myCarLabel: UILabel!
    @IBOutlet var carListButton: UIButton!
    @IBOutlet var addCarButton: UIButton!
    
    private var sectionType:MenuCarSection = .add_new_car
    private var sectionTypeItem:BehaviorRelay<MenuCarSection> = BehaviorRelay(value:.add_new_car)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setMyCarInfo(_ carInfo:String) {
        myCarLabel.text = carInfo
        sectionTypeItem.accept(.change_my_car)
    }
    
    // MARK: - Local Methods
    
    func setSectionType(_ type:MenuCarSection) {
        sectionTypeItem.accept(type)
    }
    
    func udpateLayout(_ section:MenuCarSection) {
        if section == .add_new_car {
            addNewCarView.isHidden = false
            changeMyCarView.isHidden = true
        } else {
            addNewCarView.isHidden = true
            changeMyCarView.isHidden = false
        }
    }
    
    // MARK: - Binding
    
    func setupSectionBinding() {
        sectionTypeItem
            .asDriver()
            .drive(onNext: { [unowned self] section in
                self.udpateLayout(section)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    func initialize() {
        setupSectionBinding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
