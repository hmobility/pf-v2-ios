//
//  PaymentHistoryViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class PaymentHistoryViewController: UIViewController {

    @IBOutlet weak var segmentedControlView: UIView!

    private var viewModel:PaymentHistoryViewModelType = PaymentHistoryViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
     private func setupNavigationBinding() {
           viewModel.viewTitleText
               .drive(self.navigationBar.topItem!.rx.title)
               .disposed(by: disposeBag)
           
           backButton.rx.tap
               .asDriver()
               .drive(onNext: { _ in
                   self.pop()
               })
               .disposed(by: disposeBag)
       }
       
       private func setupPaymentBinding() {
           viewModel.paymentText
               .asDriver()
               .drive(paymentButton.rx.title())
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
