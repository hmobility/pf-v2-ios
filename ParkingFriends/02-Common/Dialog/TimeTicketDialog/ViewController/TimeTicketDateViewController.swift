//
//  TimeTicketDateViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class TimeTicketDateViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nextButton: UIButton!
    
    private var startDate:Date?
    
    private var disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Binding
    
    private func setupBinding() {
        
    }
    
    private func setupButtonBinding() {
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToHoursPicker()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methd
    
    public func setStart(date:Date) {
        startDate = date
    }
    
    // MARK: - Local Methods
    
    private func initDatePicker() {
        let currentTime = startDate ?? Date()
        var start = currentTime.dateFor(.nearestMinute(minute:10))

        if Date().compare(.isLater(than: start)) == true {
            start = start.adjust(.minute, offset: 10)
        }

        datePicker.minimumDate = start
        datePicker.maximumDate = Date().dateFor(.endOfDay)
    }
        
    // MARK: - Initialize
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBinding()
        setupButtonBinding()
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        initDatePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
    
    func navigateToHoursPicker() {
        let target = Storyboard.timeTicketDialog.instantiateViewController(withIdentifier: "TimeTicketDurationViewController") as! TimeTicketDurationViewController
        
        let date = datePicker.date
        target.setStartDate(date)
        
        self.push(target)
    }
     
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
