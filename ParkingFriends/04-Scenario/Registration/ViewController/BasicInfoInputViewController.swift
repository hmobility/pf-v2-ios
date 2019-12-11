//
//  BasicInfoInputViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension BasicInfoInputViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN][REG] BasicInfo"
    }
}

class BasicInfoInputViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: CustomInputSection!
    @IBOutlet weak var emailField: CustomInputSection!
    @IBOutlet weak var passwordField: CustomInputSection!
    @IBOutlet weak var nicknameField: CustomInputSection!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    private var registrationModel: RegistrationModel = RegistrationModel.shared
    
    private lazy var viewModel: BasicInfoViewModelType = BasicInfoViewModel(phoneNumber: registrationModel.phoneNumber ?? "01043525929", registration:registrationModel)
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
     
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    //    navigateToAgreement()
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
        setupPhoneNumberBinding()
        setupEmailBinding()
        setupPasswordBinding()
        setupNicknameBinding()
        setupKeyboard()
        setupButtonBinding()
    }
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitle
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupPhoneNumberBinding() {
        viewModel.phoneNumberInputTitle
            .drive(phoneNumberField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberMessageText
            .bind(to: phoneNumberField.messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupEmailBinding() {
        viewModel.emailInputTitle
            .drive(emailField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
               
        viewModel.emailInputPlaceholder
            .drive(emailField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.emailMessageText
            .bind(to: emailField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        emailField.inputTextField.rx
            .controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext:{ _ in
                _ = self.viewModel.validateCredentials()
            })
            .disposed(by: disposeBag)
        
        emailField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(viewModel.emailModel.data)
            .disposed(by: disposeBag)
    }
    
    private func setupPasswordBinding() {
        viewModel.passwordInputTitle
            .drive(passwordField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordField.inputTextField.delegate = viewModel.passwordModel

        passwordField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(viewModel.passwordModel.data)
            .disposed(by: disposeBag)
        
        viewModel.passwordInputPlaceholder
            .drive(passwordField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.passwordMessageText
            .bind(to: passwordField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordField.inputTextField.rx
             .controlEvent([.editingDidEnd])
             .asObservable()
             .subscribe(onNext:{ _ in
                _ = self.viewModel.validateCredentials()
             })
             .disposed(by: disposeBag)
        
        passwordField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(viewModel.passwordModel.data)
            .disposed(by: disposeBag)
    }
    
    private func setupNicknameBinding() {
        viewModel.nicknameInputTitle
            .drive(nicknameField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nicknameInputPlaceholder
            .drive(nicknameField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.nicknameMessageText
            .bind(to: nicknameField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        nicknameField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(viewModel.nicknameModel.data)
            .disposed(by: disposeBag)
        
        nicknameField.inputTextField.rx
            .controlEvent([.editingChanged, .editingDidEnd])
            .asObservable()
            .subscribe(onNext:{ _ in
                _ = self.viewModel.validateCredentials()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { height in
                debugPrint("[SCROLVIEW] ", self.scrollView.frame.size.height)
                debugPrint("[VIEW] ", self.contentView.frame.size.height)
                self.nextButtonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
                self.scrollView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.saveBasicInfo()
                self.navigateToAgreement()
            })
            .disposed(by: disposeBag)
        
        viewModel.proceed.asDriver()
            .drive(onNext: { [unowned self] (completed) in
                debugPrint("[PROCEED] check all : ", completed)
                self.nextButton.isEnabled = completed ? true : false
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
      
    private func navigateToAgreement() {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "AgreementViewController") as! AgreementViewController
        self.push(target)
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
