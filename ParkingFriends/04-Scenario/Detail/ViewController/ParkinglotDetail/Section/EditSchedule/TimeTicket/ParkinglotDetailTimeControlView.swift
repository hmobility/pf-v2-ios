//
//  ParkinglotDetailTimeControlView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/29.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailTimeControlView: UIStackView {
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
    
    private var expectedStartDate:Date?
    private var expectedEndDate:Date?
    
    private var expectedMothlyDate:Date?
    
    // MARK: - Public Methods
    
    public func setOriginDate(_ date:Date, count:Int) {
        expectedMothlyDate = date
    }
    
    public func setOriginTime(start:Date, end:Date) {
        expectedStartDate = start
        expectedEndDate = end
        
        startDateInputStepper.setStartDate(start)
        startTimeInputStepper.setStartTime(start)
        
        endDateInputStepper.setStartDate(end)
        endTimeInputStepper.setStartTime(end)
    }
    
    // MARK: - Binding
    
    func setupDateBinding() {
        
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
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
