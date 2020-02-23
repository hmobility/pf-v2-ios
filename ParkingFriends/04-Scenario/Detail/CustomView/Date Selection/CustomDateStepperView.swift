//
//  CustomStepperView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import AFDateHelper

protocol CustomDateStepperViewType {
    var decreaseButton:UIButton! { get set }
    var increaseButton:UIButton! { get set }
    var dateLabel:UILabel! { get set }
    
    func setStartDate(_ date:Date)
    func getDate() -> Date
}

class CustomDateStepperView: UIView, CustomDateStepperViewType {
    @IBOutlet var decreaseButton:UIButton!
    @IBOutlet var increaseButton:UIButton!
    @IBOutlet var dateLabel:UILabel!

    var changeDateAction: ((_ year:Int, _ month:Int, _ day:Int) -> Void)?
    
    private var originDate:Date?
    private var startDate:Date?
    private var changedDate:Date?
    
    private let offsetDay = 1
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setStartDate(_ date:Date) {
        originDate = date
        startDate = date.adjust(hour: 0, minute: 0, second: 0)
        debugPrint("[DATE][START]", startDate?.toString())
        updateDate(startDate!)
    }
    
    func getDate() -> Date {
        guard changedDate != nil else {
            return startDate!
        }
        
        return changedDate!
    }
    
    // MARK: - Local Methods

    func updateDate(_ date:Date) {
        let date:String = date.toString(format:(.custom("M/d")))
        dateLabel.text = date
    }
    
    func changeDate(offset:Int){
        if let date = startDate, date.compare(.isLater(than: startDate!)) == true {
            changedDate = date.adjust(.day, offset: offset)
            debugPrint("[DATE][ADJUST]", changedDate?.toString())
            updateDate(changedDate!)
            
            if let action = changeDateAction, let date = changedDate {
                action(date.component(.year)!, date.component(.month)!, date.component(.day)!)
            }
        }
    }
    
    func increaseDay() {
        let offset = offsetDay
        changeDate(offset: offset)
    }
    
    func decreaseDay() {
        let offset = -offsetDay
        changeDate(offset: offset)
    }
    
    // MARK: - Binding
    
    func setupButtonBinding() {
        decreaseButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.decreaseDay()
            })
            .disposed(by: disposeBag)
        
        increaseButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.increaseDay()
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
