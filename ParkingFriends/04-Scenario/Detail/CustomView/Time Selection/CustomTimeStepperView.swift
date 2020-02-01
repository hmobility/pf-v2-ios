//
//  TimeStepperView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import AFDateHelper

protocol CustomTimeStepperViewType {
    var decreaseButton:UIButton! { get set }
    var increaseButton:UIButton! { get set }
    var hoursLabel:UILabel! { get set }
    var minutesLabel: UILabel! { get set }
    
    func setStartTime(_ date:Date)
    func getTime() -> Date 
}

class CustomTimeStepperView: UIView, CustomTimeStepperViewType {
    @IBOutlet var decreaseButton:UIButton!
    @IBOutlet var increaseButton:UIButton!
    @IBOutlet var hoursLabel:UILabel!
    @IBOutlet var minutesLabel:UILabel!
    
    private var startDate:Date?
    private var adjustDate:Date?
 
    private let offsetMinutes = 30
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setStartTime(_ date:Date) {
        startDate = date
        updateTime(date)
    }
    
    func getTime() -> Date {
        guard adjustDate != nil else {
            return startDate!
        }
        
        return adjustDate!
    }
    
    // MARK: - Local Methods
    
    func updateTime(_ date:Date) {
        let hours:String = date.toString(format:(.custom("h")))
        let minutes:String = date.toString(format:(.custom("m")))
        
        hoursLabel.text = hours
        minutesLabel.text = minutes
    }
    
    func changeTime(offset:Int){
        if let date = startDate, date.compare(.isLater(than: startDate!)) == true {
            adjustDate = date.adjust(.hour, offset: offset)
            updateTime(adjustDate!)
        }
    }
    
    func incrementTime() {
        let offset = offsetMinutes
        changeTime(offset: offset)
    }
    
    func decrementTime() {
        let offset = -offsetMinutes
        changeTime(offset: offset)
    }
    
    // MARK: - Binding
    
    func setupTimeBinding() {
        
    }
    
    func setupButtonBinding() {
        decreaseButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.decrementTime()
            })
            .disposed(by: disposeBag)
        
        increaseButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.incrementTime()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initializer
    
    func initialize() {
        setupButtonBinding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
         super.layoutSubviews()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
            initialize()
    }
}
