//
//  LoginViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import ActiveLabel

extension LoginViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Login"
    }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var inputAreaView: UIView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var changePhoneNumberButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var inputAreaBottomConstraint: NSLayoutConstraint!
    
    private var originalInputAreaBottomConstant: CGFloat = 0
    
    private var viewModel: LoginViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action

    @IBAction func changeNumberButtonAction(_ sender: Any) {
        navigateToChangePhoneNumber()
    }
    
    @IBAction func findPasswordButtonAction(_ sender: Any) {
        navigateToFindPassword()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        viewModel.phoneNumberPlaceholder
            .drive(phoneNumberTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.passwordPlaceholder
            .drive(passwordTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.loginText
            .drive(loginButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.changePhoneNumberText
            .drive(changePhoneNumberButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.findPasswordText
            .drive(findPasswordButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { height in
                self.inputAreaBottomConstraint.constant = height - self.view.safeAreaInsets.bottom + 15
                self.view.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        RxKeyboard.instance.isHidden
            .distinctUntilChanged()
            .drive(onNext: { hidden in
                if hidden {
                    self.inputAreaBottomConstraint.constant = self.originalInputAreaBottomConstant
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
        
        phoneNumberTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
    }
    
    private func setupInputBinding() {
        phoneNumberTextField.delegate = viewModel.phoneNumberModel
        
        phoneNumberTextField.rx.text.orEmpty
            .bind(to: viewModel.phoneNumberModel.data)
            .disposed(by: disposeBag)
        
        passwordTextField.delegate = viewModel.passwordModel
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordModel.data)
            .disposed(by: disposeBag)
    }
    
    private func setupLoginBinding() {
        loginButton.rx.tap.do(onNext: { [unowned self] in
            self.phoneNumberTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            self.viewModel.validateCredentials()
        }).disposed(by: disposeBag)
        
        viewModel.loginStatus.asDriver().asDriver(onErrorJustReturn: .none).drive(onNext: { [unowned self] status in
            switch status {
            case .none:
                break
            case .error(_):
                self.showWarning("TTT")
            case .verified:
                self.navigateToMain()
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Warnings
    
    private func showWarning(_ text:String) {
        MessageDialog.show(text)
    }
    
    // MARK: - Initialize
    
    init() {
        self.viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = LoginViewModel()
        super.init(coder: aDecoder)
    }
    
    private func storeProperty() {
        self.originalInputAreaBottomConstant = self.inputAreaBottomConstraint.constant
    }
    
    private func initialize() {
        setupBindings()
        setupKeyboard()
        setupInputBinding()
        setupLoginBinding()
    }
    
    // MARK: - Life Cycle

    override func loadView() {
        super.loadView()
        storeProperty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
    
    private func navigateToMain() {
        let target = Storyboard.main.instantiateInitialViewController() as! UINavigationController
        self.modal(target, animated: true)
    }
    
    private func navigateToChangePhoneNumber() {
        let target = Storyboard.entry.instantiateViewController(withIdentifier: "ChangePhoneNumberNavigationController") as! UINavigationController
        self.modal(target, animated: true)
    }
    
    private func navigateToFindPassword() {
        let target = Storyboard.entry.instantiateViewController(withIdentifier: "FindPasswordNavigationController") as! UINavigationController
        self.modal(target, animated: true)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
