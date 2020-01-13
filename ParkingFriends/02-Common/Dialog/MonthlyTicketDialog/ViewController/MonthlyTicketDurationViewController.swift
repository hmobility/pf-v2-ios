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
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var startDate:Date?
    private var monthRangeList:[Int] = [1, 2, 3]
    private var selectableDayDuration = 10

    var localizer:LocalizerType = Localizer.shared
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupDatePicker() {
        if let date = startDate {
            datePicker.minimumDate = date
            datePicker.maximumDate = date.adjust(.day, offset: selectableDayDuration)
        }
    }
    
    private func setupMonthPicker() {
        let rows = monthPicker.numberOfRows(inComponent: 0)
        monthPicker.selectRow((rows > 0) ? 1 : 0, inComponent: 0, animated: false)
    }
    
    private func setupBinding() {
        titleLabel.text = localizer.localized("dlg_ttl_monthly_ticket")
        fromLabel.text = localizer.localized("dlg_ttl_from")
        toLabel.text = localizer.localized("dlg_txt_duration_month")
    }
    
    private func setupButtonBinding() {
        saveButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissModal(animated: true) {
                    let index = self.monthPicker.selectedRow(inComponent: 0)
                    let months = self.monthRangeList[index]
                    
                    let start = self.datePicker.date
                    
                    if let navigation = self.navigationController, let start = self.startDate {
                        (navigation as! MonthlyTicketNavigationController).completionAction?(start, months)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func updatePickerHours() {
        Observable.just(monthRangeList)
            .bind(to: monthPicker.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
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
