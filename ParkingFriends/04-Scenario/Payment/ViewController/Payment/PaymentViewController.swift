//
//  PaymentViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/02.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton:UIButton!
    
    private lazy var viewModel:PaymentViewModelType = PaymentViewModel()
    
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
    
    // MARK: - Initialize

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupNavigationBinding()
    }
    
    // MARK: - Local Methods
    
    private func showPaymentGuideView() {
        if UserData.shared.displayPaymentGuide == true {
            navigateToPaymentGuide()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        showPaymentGuideView()
    }
    
    // MARK: - Navigation
    
    private func navigateToPaymentGuide() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentGuideViewController") as! PaymentGuideViewController
        
        self.modal(target, transparent: true, animated: false)
    }
    
    /*
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
