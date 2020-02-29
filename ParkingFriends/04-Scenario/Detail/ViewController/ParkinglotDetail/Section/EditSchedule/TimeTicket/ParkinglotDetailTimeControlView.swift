//
//  ParkinglotDetailTimeControlView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/29.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkinglotDetailTimeControlViewType {
    func setChangeOffset(_ minutes:Int)
    func setTimeRange(from start:Date, to end:Date, offset:Int)
    func getExpectedTimeRange() -> Observable<DateDuration>
    func getSelectedRange() -> Observable<DateDuration>
}

class ParkinglotDetailTimeControlView: UIStackView, ParkinglotDetailTimeControlViewType {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var startDateFieldLabel: UILabel!
    @IBOutlet weak var startDateInputStepper: CustomDateStepperView!
    @IBOutlet weak var startTimeFieldLabel: UILabel!
    @IBOutlet weak var startTimeInputStepper: CustomTimeStepperView!
    
    @IBOutlet weak var endDateFieldLabel: UILabel!
    @IBOutlet weak var endDateInputStepper: CustomDateStepperView!
    @IBOutlet weak var endTimeFieldLabel: UILabel!
    @IBOutlet weak var endTimeInputStepper: CustomTimeStepperView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    var expectedStartDate:BehaviorRelay<Date?> = BehaviorRelay(value: nil)
    var expectedEndDate:BehaviorRelay<Date?> = BehaviorRelay(value: nil)
    
    var expectedResultDuration:BehaviorRelay<DateDuration?> = BehaviorRelay(value: nil)
    
    var dayOffset:Int = 1
    var minutesOffset:Int = 10
    
    var maxStartDate:Date?
    var maxDate:Date? {
        didSet {
            if let date = maxDate {
                maxStartDate = date.adjust(.minute, offset: -minutesOffset)
            }
        }
    }
    
    var minEndDate:Date {
        get {
            return minDate.adjust(.minute, offset: minutesOffset)
        }
    }
    var minDate:Date {
        get {
            return Date()
        }
    }
    
    enum RangeType:Int {
        case start = 0
        case end = 1
    }
    
    enum DateTimeType:Int {
        case day = 0
        case time = 1
    }
    
   // var expectedMothlyDate:Date?
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setChangeOffset(_ minutes:Int = 10) {
        minutesOffset = minutes
    }
    
    public func setTimeRange(from start:Date, to end:Date, offset:Int = 30) {
        updateExpectedDate(start:start, end:end)
    }
    
    public func getExpectedTimeRange() -> Observable<DateDuration> {
        return Observable
            .combineLatest(expectedStartDate, expectedEndDate)
            .filter { $0 != nil && $1 != nil}
            .asObservable()
            .map {
                return (start:$0!, end: $1!)
            }
    }
    
    public func getSelectedRange() -> Observable<DateDuration> {
        return expectedResultDuration
            .asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }

    // MARK: - Local Methods
    
    func setExpectedResultDuration(_ duration:DateDuration) {
        expectedResultDuration.accept(duration)
    }
    
    // MARK: - Update Start/End Date
    
    func updateExpectedDate(start:Date, end:Date, range offset:Int = 3) {
        updateExpectedStartDate(start)
        updateExpectedEndDate(end)
        maxDate = Date().adjust(hour: 0, minute: 0, second: 0).adjust(.day, offset: offset)
    }
    
    func updateExpectedStartDate(_ date:Date) {
        expectedStartDate.accept(date)
        startDateInputStepper.setDisplayDate(date)
        startTimeInputStepper.setDisplayTime(date)
        
        if let start = expectedStartDate.value, let end = expectedEndDate.value, end.compare(.isEarlier(than: start)) {
            let changed = start.adjust(.minute, offset: minutesOffset)
            updateExpectedEndDate(changed)
        }
    }
    
    func updateExpectedEndDate(_ date:Date) {
        expectedEndDate.accept(date)
        endDateInputStepper.setDisplayDate(date)
        endTimeInputStepper.setDisplayTime(date)
        
        if let start = expectedStartDate.value, let end = expectedEndDate.value, end.compare(.isEarlier(than: start)) {
            let changed = end.adjust(.minute, offset: -minutesOffset)
            updateExpectedStartDate(changed)
        }
    }
    
    // MARK: - Change Date/Time
    
    func changeDateAndTime(range:RangeType, type:DateTimeType, offset:Int){
        if range == .start {
            if let start = expectedStartDate.value, let maxStart = maxStartDate {
                let changed = start.adjust(((type == .day) ? .day : .minute), offset: offset)
                
                if changed.compare(.isLater(than: minDate)) == true && changed.compare(.isEarlier(than: maxStart)) == true {
                    updateExpectedStartDate(changed)
                } else if changed.compare(.isLater(than: maxStart)) == true {
                    updateExpectedStartDate(maxStart)
                } else if changed.compare(.isEarlier(than: minDate)) == true  {
                    updateExpectedStartDate(minDate)
                }
            }
        } else if range == .end {
            if  let start = expectedStartDate.value, let end = expectedEndDate.value, let max = maxDate {
                let startMin = start.adjust(.minute, offset: minutesOffset)
                let changed = end.adjust(((type == .day) ? .day : .minute), offset: offset)
        
                if changed.compare(.isEarlier(than: max)) == true && changed.compare(.isLater(than: minEndDate)) == true {
                    updateExpectedEndDate(changed)
                } else if changed.compare(.isLater(than: max)) == true {
                    updateExpectedEndDate(max)
                } else if changed.compare(.isEarlier(than: startMin)) == true {
                    updateExpectedEndDate(startMin)
                }
            }
        }
    }

    // MARK: - Increase/Decrese Methods
    
    func increaseDay(range:RangeType) {
        let offset = dayOffset
        changeDateAndTime(range: range, type: .day, offset: offset)
       // changeDate(range: range, offset: offset)
    }
    
    func decreaseDay(range:RangeType) {
        let offset = -dayOffset
        changeDateAndTime(range: range, type: .day, offset: offset)
        //changeDate(range: range, offset: offset)
    }
    
    func increaseTime(range:RangeType) {
        let offset = minutesOffset
      //  changeTime(range: range, offset: offset)
        changeDateAndTime(range: range, type: .time, offset: offset)
    }
    
    func decreaseTime(range:RangeType) {
        let offset = -minutesOffset
      //  changeTime(range: range, offset: offset)
        changeDateAndTime(range: range, type: .time, offset: offset)
    }
    
    // MARK: - Binding
    
    func setupStartButtonBinding() {
        startDateInputStepper
            .increaseButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.increaseDay(range: .start)
            })
            .disposed(by: disposeBag)
        
        startDateInputStepper
            .decreaseButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.decreaseDay(range: .start)
            })
            .disposed(by: disposeBag)
        
        startTimeInputStepper
            .increaseButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.increaseTime(range: .start)
            })
            .disposed(by: disposeBag)
        
        startTimeInputStepper
            .decreaseButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.decreaseTime(range: .start)
            })
            .disposed(by: disposeBag)
    }
    
    func setupEndButtonBinding() {
        endDateInputStepper
            .increaseButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.increaseDay(range: .end)
            })
            .disposed(by: disposeBag)
        
       endDateInputStepper
            .decreaseButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.decreaseDay(range: .end)
            })
            .disposed(by: disposeBag)
        
        endTimeInputStepper
            .increaseButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.increaseTime(range: .end)
            })
            .disposed(by: disposeBag)
        
        endTimeInputStepper
            .decreaseButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.decreaseTime(range: .end)
            })
            .disposed(by: disposeBag)
    }
    
    func setupButtonBinding() {
        applyButton.rx.tap
            .asDriver()
            .map { _ in
                return DateDuration(start:self.expectedStartDate.value!, end:self.expectedEndDate.value!)
            }
            .drive(onNext: { [unowned self] duration in
                self.setExpectedResultDuration(duration)
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
        setupEndButtonBinding()
        setupButtonBinding()
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        initialize()
    }
}
