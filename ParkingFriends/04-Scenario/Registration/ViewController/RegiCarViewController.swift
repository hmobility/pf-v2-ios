//
//  RegisteringCarViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension RegiCarViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Registering Car Info"
    }
}

class RegiCarViewController: UIViewController {
    
    @IBOutlet weak var carBrandField: CustomInputSection!
    @IBOutlet weak var carNumberField: CustomInputSection!
    @IBOutlet weak var carColorField: CustomInputSection!
    
    @IBOutlet weak var skipButton: UIBarButtonItem!
    @IBOutlet weak var selectCarButton: UIButton!
    @IBOutlet weak var selectColorButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    private var registrationModel: RegistrationModel = RegistrationModel.shared
    
    private lazy var viewModel: RegiCarViewModelType = RegiCarViewModel(carInfo: CarNumberModel(), registration:registrationModel)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
       // navigateToRegiCar()
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
        setupCarBrandBinding()
        setupCarNumberBinding()
        setupCarColorBinding()
        setupButtonBinding()
        setupKeyboard()
    }
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitle
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupCarBrandBinding() {
        viewModel.carBrandInputTitle
            .drive(carBrandField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
               
        viewModel.carBrandPlaceholder
            .drive(carBrandField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.carBrandText
            .asDriver()
            .drive(carBrandField.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.carBrandMessageText
            .asDriver()
            .drive(carBrandField.messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupCarNumberBinding() {
        viewModel.carNumberInputTitle
            .drive(carNumberField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
               
        viewModel.carNumberPlaceholder
            .drive(carNumberField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.carNumberMessageText
            .asDriver()
            .drive(carNumberField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        carNumberField.inputTextField.rx
            .controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext:{ _ in
                _ = self.viewModel.validateCredentials()
            })
            .disposed(by: disposeBag)
        
        carNumberField.inputTextField.rx.text
            .orEmpty
            .subscribe(onNext: { text in
                self.viewModel.carInfo.number.accept(text)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCarColorBinding() {
        viewModel.carColorInputTitle
            .drive(carColorField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
               
        viewModel.carColorPlaceholder
            .drive(carColorField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)

        viewModel.carColorText
            .asDriver()
            .drive(carColorField.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.carColorMessageText
             .asDriver()
             .drive(carColorField.messageLabel.rx.text)
             .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { height in
                self.nextButtonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        skipButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToRegiCreditCard()
            })
            .disposed(by: disposeBag)
        
        selectCarButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToRegiCar()
            })
            .disposed(by: disposeBag)
        
        selectColorButton.rx.tap
            .subscribe(onNext: { _ in
                self.showColorDiaglog()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.registerCarInfo { success in
                    if success {
                         self.navigateToRegiCreditCard()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.proceed.asDriver()
            .drive(onNext: { [unowned self] flag in
                self.nextButton.isEnabled = flag ? true : false
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func update() {
        
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
    
    private func navigateToRegiCar() {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "CarBrandViewController") as! CarBrandViewController
  
        target.dismissed = { (model, brand) in
            self.registrationModel.setCarModel(model, brand: brand)
            self.viewModel.updateCarModel()
        }

        self.modal(target)
    }
    
    private func navigateToRegiCreditCard() {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "RegiCreditCardViewController") as! RegiCreditCardViewController
        self.push(target)
    }
    
    private func showColorDiaglog() {
        ColorDialog.show { (finished, color) in
            if finished {
                self.viewModel.setCarColor(color!)
            }
        }
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
