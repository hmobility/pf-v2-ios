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
    
    @IBOutlet weak var totalPriceTitleLabel:UILabel!
    @IBOutlet weak var totalPriceLabel:UILabel!
    
    @IBOutlet weak var paymentButton:UIButton!
    
    @IBOutlet weak var paymentParkingInfoView: ParkingTicketInfoView!
    @IBOutlet weak var paymentMehodView: PaymentMethodView!
    @IBOutlet weak var paymentPointView: PaymentPointView!
    @IBOutlet weak var paymentGiftView: PaymentGiftView!
    @IBOutlet weak var paymentAgreementView: PaymentAgreementView!
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
      
    private var viewModel:PaymentViewModelType = PaymentViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitleText
            .drive(self.navigationBar.topItem!.rx.title)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismissProcess()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPaymentBinding() {
        viewModel.getOrderPreview()
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [unowned self] preview in
                self.updateOrderPreview(preview)
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
        viewModel.giftText
            .asDriver()
            .drive(giftButton.rx.title())
            .disposed(by: disposeBag)
        
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
    
    private func setupPriceBinding() {
        viewModel.totalPriceTitleText
            .drive(totalPriceTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.getPaymentPrice()
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupAgreementBinding() {
        paymentAgreementView.getAgreementState()
            .subscribe(onNext: { checked in
            
            })
            .disposed(by: disposeBag)
        /*
        paymentAgreementView.checkButton.rx.tap
                 .map {
                    return !self.paymentAgreementView.checkButton.isSelected
                 }
                .bind(to: self.paymentAgreementView.checkButton.rx.isSelected)
                 .disposed(by: disposeBag)
        */
        paymentAgreementView
            .tapReminderButton()
            .drive(onNext: { [unowned self] _ in
                self.navigateToPaymentGuide(false)
            })
         .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        viewModel.paymentText
            .asDriver()
            .drive(paymentButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { height in
                self.buttonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.isHidden
            .distinctUntilChanged()
            .drive(onNext: { hidden in
                if hidden {
                    self.buttonBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Public Methods
    
    // MARK: - Local Methods
    
    private func updateOrderPreview(_ preview:OrderPreview) {
        if self.paymentParkingInfoView != nil {
            self.paymentParkingInfoView.setParkingInfo(with: preview)
        }
        
        if self.paymentPointView != nil {
            self.paymentPointView.setUserPoints(preview.point)
        }
        
        setPaymentPrice(with: preview.totalAmount)
    }
    
    private func setPaymentPrice(with price:Int) {
        viewModel.setPaymentPrice(price)
    }
    
    private func showPaymentGuideView() {
        if UserData.shared.displayPaymentGuide == true {
            navigateToPaymentGuide()
        }
    }
    
    private func showGiftView(_ flag:Bool) {
        paymentGiftView.isHidden = flag ? false : true
    }
    
    private func dismissProcess() {
        if let navigation = navigationController {
            if navigation.viewControllers.count > 1 {
                self.pop()
            } else {
                self.dismissRoot()
            }
        } else {
            self.dismissModal()
        }
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
        setupPriceBinding()
        setupButtonBinding()
        setupKeyboard()
        setupAgreementBinding()
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
    
    private func navigateToPaymentGuide(_ showChecking:Bool = true) {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentGuideViewController") as! PaymentGuideViewController
        target.showCheckMdode(showChecking)
        
        target.dismissAction = { [unowned self] flag in
            if showChecking {
                self.dismissRoot()
            }
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

// MARK: - Data Setter / Getter

extension PaymentViewController {
    public func setOrderForm(_ form:TicketOrderFormType) {
        viewModel.setOrderForm(form)
    }
    
    public func setData(parkinglot data:Parkinglot) {
        viewModel.setParkinglotInfo(data)
    }
    
    public func setProductElement(_ element:ProductElement) {
        viewModel.setProductElement(element)
    }
    
    public func setGiftMode(_ flag:Bool) {
        viewModel.setGiftMode(flag)
    }
}
