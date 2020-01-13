//
//  TimeStepperView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import AFDateHelper

protocol TimeStepperViewType {
    var previousButton:UIButton! { get set }
    var nextButton:UIButton! { get set }
    var hoursLabel:UILabel! { get set }
    var minutesLabel: UILabel! { get set }
    
    func setStartTime(_ date:Date)
    func getTime() -> Date 
}

class TimeStepperView: UIView, TimeStepperViewType {
    @IBOutlet var previousButton:UIButton!
    @IBOutlet var nextButton:UIButton!
    @IBOutlet var hoursLabel:UILabel!
    @IBOutlet var minutesLabel:UILabel!
    
    private var start:Date?
    private var adjust:Date?
 
    private let offsetMinutes = 30
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setStartTime(_ date:Date) {
        start = date
        updateTime(date)
    }
    
    func getTime() -> Date {
        guard adjust != nil else {
            return start!
        }
        
        return adjust!
    }
    
    // MARK: - Local Methods
    
    func updateTime(_ date:Date) {
        let hours:String = date.toString(format:(.custom("h")))
        let minutes:String = date.toString(format:(.custom("m")))
        
        hoursLabel.text = hours
        minutesLabel.text = minutes
    }
    
    func chagneTime(offset:Int){
        if let date = start, date.compare(.isLater(than: start!)) == true {
            adjust = date.adjust(.hour, offset: offset)
            updateTime(adjust!)
        }
    }
    
    func incrementTime() {
        let offset = offsetMinutes
        chagneTime(offset: offset)
    }
    
    func decrementTime() {
        let offset = -offsetMinutes
        chagneTime(offset: offset)
    }
    
    // MARK: - Binding
    
    func setupTimeBinding() {
        
    }
    
    func setupButtonBinding() {
        previousButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.decrementTime()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
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
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
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
