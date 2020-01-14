//
//  ExtendDurationViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/13.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ExtendDurationViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var extendDurationTitleLabel: UILabel!
    @IBOutlet weak var hoursPicker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
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
    
    private func setupBinding() {
        extendDurationTitleLabel.text = localizer.localized("ttl_extend_duration")
    }
    
    private func setupButtonBinding() {
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissModal(animated: true)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissModal(animated: true) {
                    let index = self.hoursPicker.selectedRow(inComponent: 0)
                    let hours = self.hourRangeList[index]
                    if let navigation = self.navigationController, let start = self.startDate {
                        (navigation as! FixedTicketNavigationController).completeAction?(start, hours)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
