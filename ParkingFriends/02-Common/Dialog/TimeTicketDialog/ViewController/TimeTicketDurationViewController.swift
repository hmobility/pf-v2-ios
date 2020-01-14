//
//  TimeTicketDurationViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class TimeTicketDurationViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var hoursPicker: UIPickerView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var startDate:Date?
    private var hourRangeList:[Int] = []

    var localizer:LocalizerType = Localizer.shared
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupHoursPicker() {
        let rows = hoursPicker.numberOfRows(inComponent: 0)
        hoursPicker.selectRow((rows > 0) ? 1 : 0, inComponent: 0, animated: false)
    }
    
    private func setupButtonBinding() {
        previousButton.rx.tap
            .subscribe(onNext: { _ in
                self.pop()
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissModal(animated: true) {
                    let index = self.hoursPicker.selectedRow(inComponent: 0)
                    let hours = self.hourRangeList[index]
                    if let navigation = self.navigationController, let start = self.startDate {
                        (navigation as! TimeTicketNavigationController).completeAction?(start, start.adjust(.hour, offset: hours))
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func setStartDate(_ date:Date) {
        startDate = date
    }
    
    // MARK: - Local Methods
    
    private func updatePickerHours() {
        if let date = startDate {
            let maxHours:Int = 24 - date.component(.hour)!
            hourRangeList = Array(1...maxHours)
            let fromDate = DisplayTimeHandler().diplayTimeTicketFromDate(date: date)
            
            Observable.just(fromDate)
                .bind(to: resultLabel.rx.text)
                .disposed(by: disposeBag)
            
            Observable.just(hourRangeList)
                .bind(to: hoursPicker.rx.itemTitles) { _, item in
                    return "\(item)"
                }
                .disposed(by: disposeBag)
        }
    }
        
    // MARK: - Initialize
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupButtonBinding()
        setupHoursPicker()
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        updatePickerHours()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
     
    func navigateToHoursPicker() {
        let target = Dialog.timeTicket.instantiateViewController(withIdentifier: "TimeTicketDurationViewController") as! TimeTicketDurationViewController
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
