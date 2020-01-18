//
//  MonthlyTicketDurationViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MonthlyTicketDurationViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var durationMonthLabel: UILabel!
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var startDate:Date?
    private var dayRangeList:[Int] = []
    private var monthRangeList:[Int] = [1, 2, 3]
    private var selectableDayDuration = 10

    var localizer:LocalizerType = Localizer.shared
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Binding
        
    private func setupMonthPicker() {
        let rows = durationPicker.numberOfRows(inComponent: 0)
        durationPicker.selectRow((rows > 0) ? 1 : 0, inComponent: 0, animated: false)
    }
    
    private func setupBinding() {
        titleLabel.text = localizer.localized("dlg_ttl_monthly_ticket")
        fromLabel.text = localizer.localized("dlg_txt_from")
        durationMonthLabel.text = localizer.localized("dlg_txt_duration_month")
    }
    
    private func setupButtonBinding() {
        saveButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissModal(animated: true) {
                    let start = self.getStartDate()
                    let months = self.getMonth()
        
                    if let navigation = self.navigationController {
                        (navigation as! MonthlyTicketNavigationController).completeAction?(start, months)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func getStartDate() -> Date {
        let index = self.dayPicker.selectedRow(inComponent: 0)
        let offset = self.dayRangeList[index]
        return (startDate?.adjust(.day, offset: offset))!
    }
    
    private func getMonth() -> Int {
        let index = self.durationPicker.selectedRow(inComponent: 0)
        return self.monthRangeList[index]
    }
    
    private func updatePicker() {
        if let date = startDate {
            let startDay = date.component(.day)!
            let endDay = startDay + selectableDayDuration
            dayRangeList = Array(startDay ... endDay)
        }
        
        let unit = self.localizer.localized("txt_day_unit") as String
        
        Observable.just(dayRangeList)
            .bind(to: dayPicker.rx.itemTitles) { [unowned self] index, item in
                switch index {
                case 0:
                    return self.localizer.localized("txt_today") as String
                case 1:
                    return self.localizer.localized("txt_tomorrow") as String
                default:
                    return  "\(item)\(unit)"
                }
            }
            .disposed(by: disposeBag)
        
        Observable.just(monthRangeList)
            .bind(to: durationPicker.rx.itemTitles) { _, item in
                return "\(item)"
             }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
     
     public func setStartDate(_ date:Date) {
         startDate = date
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
        setupMonthPicker()
        setupBinding()
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        updatePicker()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
