//
//  PaymentDataUsageViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension PaymentDataUsageViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Data Usage Warning"
    }
}

class PaymentDataUsageViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var selectAction: ((_ flag:Bool) -> Void)?
    
    private var viewModel:ParkingDataUsageViewModelType = ParkingDataUsageViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.titleText
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.descText
            .asDriver()
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dismissText
            .asDriver()
            .drive(dismissButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.confirmText
            .asDriver()
            .drive(confirmButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        confirmButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismissModal(animated: false) {
                     if let action = self.selectAction {
                        action(true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismissModal(animated: false) {
                    if let action = self.selectAction {
                        action(true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
        setupButtonBinding()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
