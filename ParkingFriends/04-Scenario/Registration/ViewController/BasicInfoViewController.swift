//
//  BasicInfoInputViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension BasicInfoViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN][REG] BasicInfo"
    }
}

class BasicInfoViewController: UIViewController {
    @IBOutlet weak var phoneNumberField: CustomInputSection!
    @IBOutlet weak var emailField: CustomInputSection!
    @IBOutlet weak var passwordField: CustomInputSection!
    @IBOutlet weak var nicknameField: CustomInputSection!
    
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
        
        viewModel.phoneNumberDisplayText.asDriver()
            .drive(phoneNumberField.displayTextLabel.rx.text)
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
    
        emailField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section: .email)
            })
            .disposed(by: disposeBag)
        
        let inputEvents:Observable<Bool> = Observable.merge([
            emailField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
            emailField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
        ])
        
        inputEvents.asObservable()
            .subscribe(onNext: { editing in
                _ = self.viewModel.validateCredentials(section:.email, editing:editing)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPasswordBinding() {
        viewModel.passwordInputTitle
            .drive(passwordField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        //passwordField.inputTextField.delegate = viewModel.passwordModel

        passwordField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section: .password)
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordInputPlaceholder
            .drive(passwordField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.passwordMessageText
            .bind(to: passwordField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section: .password)
            })
            .disposed(by: disposeBag)
        
        let inputEvents:Observable<Bool> = Observable.merge([
            passwordField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
            passwordField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
        ])
        
        inputEvents.asObservable()
            .subscribe(onNext: { editing in
                _ = self.viewModel.validateCredentials(section:.password, editing:editing)
            })
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
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section: .nickname)
            })
            .disposed(by: disposeBag)
        
        let inputEvents:Observable<Bool> = Observable.merge([
            nicknameField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
            nicknameField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
        ])
        
        inputEvents.asObservable()
            .subscribe(onNext: { editing in
                _ = self.viewModel.validateCredentials(section:.nickname, editing:editing)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        RxKeyboard.instance.visibleHeight
            .distinctUntilChanged()
            .drive(onNext: { height in
                self.nextButtonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
                self.scrollView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.nextProcess()
            })
            .disposed(by: disposeBag)
        
        
        viewModel.proceed.asDriver()
            .drive(onNext: { [unowned self] (type, message) in
                switch type {
                case .none, .disabled:
                    self.nextButton.isEnabled = false
                case .enabled:
                    self.nextButton.isEnabled = true
                case .success:
                    self.navigateToAgreement()
                case .failure:
                    MessageDialog.show(message)
                    break
                }
            })
            .disposed(by: disposeBag)
        /*
        viewModel.proceed.asDriver()
            .drive(onNext: { [unowned self] (completed) in
                self.nextButton.isEnabled = completed ? true : false
            })
            .disposed(by: disposeBag)
 */
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
