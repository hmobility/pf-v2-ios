//
//  DateTimeViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class TimeTicketDateViewController: UIViewController {
    @IBOutlet weak var titleLabel: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nextButton: UIButton!
    
    var disposeBag = DisposeBag()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
    
    func navigateToHoursPicker() {
        let target = Storyboard.timeTicketDialog.instantiateViewController(withIdentifier: "TimeTicketDurationViewController") as! TimeTicketDurationViewController
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