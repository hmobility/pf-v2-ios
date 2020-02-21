//
//  PaymentHistoryEmptyReservationViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class PaymentHistoryEmptyPaidTicketViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var viewModel: PaymentHistoryEmptyViewModelType = PaymentHistoryEmptyViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.emptyReservationTitleText
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emptyReservationDescText
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initiailize
    
    private func initialize() {
        setupBinding()
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
