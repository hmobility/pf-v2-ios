//
//  CustomStepperView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import AFDateHelper

protocol DateStepperViewType {
    var previousButton:UIButton! { get set }
    var nextButton:UIButton! { get set }
    var dateLabel:UILabel! { get set }
    
    func setStartDate(_ date:Date)
    func getDate() -> Date
}

class DateStepperView: UIView, DateStepperViewType {
    @IBOutlet var previousButton:UIButton!
    @IBOutlet var nextButton:UIButton!
    @IBOutlet var dateLabel:UILabel!

    private var start:Date?
    private var adjust:Date?
    
    private let offsetDay = 1
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setStartDate(_ date:Date) {
        start = date
        updateDate(date)
    }
    
    func getDate() -> Date {
        guard adjust != nil else {
            return start!
        }
        
        return adjust!
    }
    
    // MARK: - Local Methods
    
    func updateDate(_ date:Date) {
        let date:String = date.toString(format:(.custom("M/d")))
        dateLabel.text = date
    }
    
    func chagneDate(offset:Int){
        if let date = start, date.compare(.isLater(than: start!)) == true {
            adjust = date.adjust(.day, offset: offset)
            updateDate(adjust!)
        }
    }
    
    func incrementDay() {
        let offset = offsetDay
        chagneDate(offset: offset)
    }
    
    func decrementDay() {
        let offset = -offsetDay
        chagneDate(offset: offset)
    }
    
    // MARK: - Binding
    
    func setupTimeBinding() {
        
    }
    
    func setupButtonBinding() {
        previousButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.decrementDay()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.incrementDay()
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
