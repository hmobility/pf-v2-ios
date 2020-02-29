//
//  ParkinglotDetailMonthlyControlView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkinglotDetailMonthlyControlViewType {
    func setChangeOffset(_ day:Int)
    func setPeriod(from start:Date, period:Int)
    func getSelectedRange() -> Observable<DateDuration>
    func getExpectedDateRange() -> Observable<DateDuration>
}

class ParkinglotDetailMonthlyControlView: UIStackView, ParkinglotDetailMonthlyControlViewType {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var startDateFieldLabel: UILabel!
    @IBOutlet weak var startDateInputStepper: CustomDateStepperView!
    
    @IBOutlet weak var periodOfMonthFieldLabel: UILabel!
    @IBOutlet weak var periodOfMonthInputStepper: CustomDateStepperView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    var expectedStartDate:BehaviorRelay<Date?> = BehaviorRelay(value: nil)
    var expectedMonthCount:BehaviorRelay<Int> = BehaviorRelay(value: 1)
    
    var expectedResultDuration:BehaviorRelay<DateDuration?> = BehaviorRelay(value: nil)
    
    var basicDaysPerMonth = 30
    var dayOffset:Int = 1
    
    var maxLimitDay:Int = 7
    var monthOffset:Int = 1
    var maxMonthCount:Int = 3
    
    var maxDate:Date?
    var minDate:Date {
        get {
            return Date()
        }
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setChangeOffset(_ day:Int = 1) {
        dayOffset = day
    }
    
    public func setPeriod(from start:Date, period:Int = 1) {
        setExpectedDate(start: start, maxCount: maxLimitDay)
        updateExpectedMonthlyPeriod(period)
    }
    
    public func getSelectedRange() -> Observable<DateDuration> {
        return expectedResultDuration.asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }
    
    func getExpectedDateRange() -> Observable<DateDuration> {
        return Observable
            .combineLatest(expectedStartDate, expectedMonthCount)
            .filter { $0.0 != nil }
            .map { ($0.0!, $0.1) }
            .map { [unowned self] (start, count) in
                let end = start.adjust(.day, offset: (count * self.basicDaysPerMonth))
                return (start:start, end:end)
            }
    }
    
    // MARK: - Local Methods
    
    func updateExpectedResult() {
        if let start = self.expectedStartDate.value {
            let offset = self.expectedMonthCount.value * basicDaysPerMonth
            let end = start.adjust(.day, offset: offset)
            let duration = DateDuration(start: start, end: end)
             expectedResultDuration.accept(duration)
        }
    }
    
    // MARK: - Update Date
    
    func setExpectedDate(start:Date, maxCount:Int = 7) {
        updateExpectedDate(start)
        maxDate = Date().adjust(hour: 0, minute: 0, second: 0).adjust(.day, offset: maxCount)
    }
    
    func updateExpectedDate(_ date:Date) {
        expectedStartDate.accept(date)
        startDateInputStepper.setDisplayDate(date)
    }
    
    func updateExpectedMonthlyPeriod(_ count:Int) {
        expectedMonthCount.accept(count)
        periodOfMonthInputStepper.setDisplayCount(count)
    }
    
    func changeDate(offset:Int){
        if let start = expectedStartDate.value, let max = maxDate {
            let changed = start.adjust(.day, offset: offset)

            if changed.compare(.isLater(than: minDate)) == true  && changed.compare(.isEarlier(than: max)) == true {
                updateExpectedDate(changed)
            }
        }
    }
    
    func changeMonthCount(offset:Int) {
        let changed = expectedMonthCount.value + offset
        if changed > 0 && changed <= maxMonthCount {
            updateExpectedMonthlyPeriod(changed)
        }
    }
    
    // MARK: - Change Date
    
    func increaseDay() {
        let offset = dayOffset
        changeDate(offset: offset)
    }
    
    func decreaseDay() {
        let offset = -dayOffset
        changeDate(offset: offset)
    }
    
    func increaseCount() {
        let offset = monthOffset
        changeMonthCount(offset: offset)
    }
    
    func decreaseCount() {
        let offset = -monthOffset
        changeMonthCount(offset: offset)
    }
    
    // MARK: - Binding
    
    func setupStartButtonBinding() {
        startDateInputStepper
            .increaseButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.increaseDay()
            })
            .disposed(by: disposeBag)
        
        startDateInputStepper
            .decreaseButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.decreaseDay()
            })
            .disposed(by: disposeBag)
    }
    
    func setupPeriodOfMonthButtonBinding() {
        periodOfMonthInputStepper
            .increaseButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.increaseCount()
            })
            .disposed(by: disposeBag)
        
        periodOfMonthInputStepper
            .decreaseButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.decreaseCount()
            })
            .disposed(by: disposeBag)
    }
    
    func setupButtonBinding() {
        applyButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] duration in
                self.updateExpectedResult()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
        setupStartButtonBinding()
        setupPeriodOfMonthButtonBinding()
        setupButtonBinding()
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
