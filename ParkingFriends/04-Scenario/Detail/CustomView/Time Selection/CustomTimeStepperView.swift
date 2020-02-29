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
    
    var displayTime:BehaviorRelay<Date?> { get }
       
    func setDisplayTime(_ time:Date)
}

class CustomTimeStepperView: UIView, CustomTimeStepperViewType {
    @IBOutlet var decreaseButton:UIButton!
    @IBOutlet var increaseButton:UIButton!
    @IBOutlet var hoursLabel:UILabel!
    @IBOutlet var minutesLabel:UILabel!
    
    var displayTime:BehaviorRelay<Date?> = BehaviorRelay(value: nil)
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setDisplayTime(_ time:Date) {
        updateTime(time)
    }

    // MARK: - Local Methods
    
    func updateTime(_ date:Date) {
        let hours:String = date.toString(format:(.custom("HH")))
        let minutes:String = date.toString(format:(.custom("MM")))
        
        hoursLabel.text = hours
        minutesLabel.text = minutes
    }

    // MARK: - Binding

     func setupDateBinding() {
         displayTime.asObservable()
                .distinctUntilChanged()
                .filter { $0 != nil }
                .map { $0! }
                .subscribe(onNext: { [unowned self] time in
                    self.updateTime(time)
                })
                .disposed(by: disposeBag)
     }
     
    // MARK: - Initializer
    
    func initialize() {
        setupDateBinding()
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
