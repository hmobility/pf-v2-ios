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
    
    @IBOutlet weak var paymentParkingInfoView: ParkingTicketInfoView!
    @IBOutlet weak var paymentMehodView: PaymentMethodView!
    @IBOutlet weak var paymentPointView: PaymentPointView!
    
    @IBOutlet weak var paymentGiftView: PaymentGiftView!
    
    private var viewModel:PaymentViewModelType = PaymentViewModel()
    
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
        viewModel.getOrderPreview()
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [unowned self] preview in
                self.paymentParkingInfoView.setParkingInfo(with: preview)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupGiftBinding() {
        /*
        giftButton.rx.tap
            .asObservable()
            .map { return !self.giftButton.isSelected }
            .map { selected in
                self.giftButton.isSelected = selected
                return selected
            }
            .bind(to:viewModel.giftMode)
            .disposed(by: disposeBag)
        */
        viewModel.giftMode
            .asDriver()
            .drive(giftButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.giftMode
            .asDriver()
            .drive(onNext: { [unowned self] flag in
                self.showGiftView(flag)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        viewModel.paymentText
            .asDriver()
            .drive(paymentButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    // MARK: - Publid Methods
    
    public func setData(parkinglot data:Parkinglot) {
        viewModel.setParkinglotInfo(data)
    }
    
    public func setProductElement(_ element:ProductElement) {
        viewModel.setProductElement(element)
    }
    
    public func setGiftMode(_ flag:Bool) {
        viewModel.setGiftMode(flag)
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
        setupButtonBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPaymentGuideView()
    }
    
    // MARK: - Navigation
    
    private func navigateToPaymentGuide() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentGuideViewController") as! PaymentGuideViewController
        
        target.dismissAction = { flag in
            self.dismissRoot()
        }

        self.modal(target, transparent: true, animated: true)
    }
    
    /*
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
