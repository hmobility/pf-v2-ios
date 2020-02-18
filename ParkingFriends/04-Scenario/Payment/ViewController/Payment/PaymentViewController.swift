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
    @IBOutlet weak var giftButton:UIButton!
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var paymentButton:UIButton!
    
    @IBOutlet weak var productInfoView:PaymentProductInfoView!
    @IBOutlet weak var paymentMehodView: PaymentMethodView!
    @IBOutlet weak var paymentPointView: PaymentPointView!
    
    @IBOutlet weak var paymentGiftView: PaymentGiftView!
    
    private var viewModel:PaymentViewModelType = PaymentViewModel()
    private var parkinglot:Parkinglot?
    
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
    
    private func setupGiftBinding() {
        giftButton.rx.tap
            .asObservable()
            .map { return !self.giftButton.isSelected }
            .subscribe(onNext: { [unowned self] selected in
                self.giftButton.isSelected = selected
                self.showGiftView(selected ? true : false)
             })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Publid Methods
    
    public func setData(parkinglot:Parkinglot) {
        self.parkinglot = parkinglot
    }
    
    // MARK: - Local Methods
    
    private func showPaymentGuideView() {
        if UserData.shared.displayPaymentGuide == true {
            navigateToPaymentGuide()
        }
    }
    
    private func showGiftView(_ flag:Bool) {
        paymentGiftView.isHidden = flag ? false : true
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
        setupGiftBinding()
        setupPaymentBinding()
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
