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
    
    var displayDate:BehaviorRelay<Date?> { get }
    
    func setDisplayDate(_ date:Date)
    /*
    func setStartDate(_ date:Date, min minDate:Date)
    func setEndDate(_ date:Date, max maxDate:Date)
    func getDate() -> Date
 */
}

class CustomDateStepperView: UIView, CustomDateStepperViewType {
    @IBOutlet var decreaseButton:UIButton!
    @IBOutlet var increaseButton:UIButton!
    @IBOutlet var dateLabel:UILabel!
    
    var displayDate:BehaviorRelay<Date?> = BehaviorRelay(value: nil)
    var displayMonthCount:BehaviorRelay<Int?> = BehaviorRelay(value: nil)
/*
    var changeDateAction: ((_ year:Int, _ month:Int, _ day:Int) -> Void)?
    
    private var originDate:Date?
    private var startDate:Date?
    private var changedDate:Date?
    
    private var minDate:Date?
    private var maxDate:Date?
    
    private let offsetDay = 1
    */
    
    var localizer:LocalizerType = Localizer.shared
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setDisplayDate(_ date:Date) {
        displayDate.accept(date)
       // updateDate(date)
    }
    
    public func setDisplayCount(_ count:Int) {
        displayMonthCount.accept(count)
          // updateDate(date)
       }
    /*
    public func setStartDate(_ date:Date, min minDate:Date) {
        self.originDate = date
        self.startDate = date.adjust(hour: 0, minute: 0, second: 0)
        self.minDate = minDate
        debugPrint("[DATE][START]", date.toString())
        updateDate(startDate!)
    }
    
    public func setEndDate(_ date:Date, max maxDate:Date) {
        self.originDate = date
        self.startDate = date
        self.maxDate = maxDate
        
        updateDate(startDate!)
    }
    
    func getDate() -> Date {
        guard changedDate != nil else {
            return startDate!
        }
        
        return changedDate!
    }
    */
    // MARK: - Local Methods

    func updateDate(_ date:Date) {
        let date:String = date.toString(format:(.custom("M/d")))
        dateLabel.text = date
    }
    
    func updateMonth(count:Int) {
        let date:String = "\(count)\(localizer.localized("txt_months"))"
        dateLabel.text = date
    }
    /*
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
    */
    // MARK: - Binding
    
    func setupDateBinding() {
        displayDate.asObservable()
            .distinctUntilChanged()
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [unowned self] date in
                self.updateDate(date)
            })
            .disposed(by: disposeBag)
        
        displayMonthCount.asObservable()
            .distinctUntilChanged()
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [unowned self] count in
                self.updateMonth(count: count)
            })
            .disposed(by: disposeBag)
    }
    /*
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
    */
    // MARK: - Initializer
    
    func initialize() {
        setupDateBinding()
      //  setupButtonBinding()
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
        initialize()
    }

     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
       // initialize()
     }
}
