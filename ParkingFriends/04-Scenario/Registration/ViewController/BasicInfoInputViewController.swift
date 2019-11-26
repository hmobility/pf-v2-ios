//
//  BasicInfoInputViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasicInfoInputViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: CustomInputSection!
    @IBOutlet weak var emailField: CustomInputSection!
    @IBOutlet weak var passwordField: CustomInputSection!
    @IBOutlet weak var nicknameField: CustomInputSection!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    
    private var viewModel: BasicInfoViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
     
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigateToAgreement()
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        
        // Phone Number
        viewModel.placeholder(textField: phoneNumberField.inputTextField, "phone_number_input_placeholder")
        
        viewModel.phoneNumberInputTitle
            .bind(to: phoneNumberField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberMessageText
            .bind(to: phoneNumberField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        // e-mail
        
        viewModel.placeholder(textField: emailField.inputTextField, "email_input_placeholder")
        
        viewModel.emailInputTitle
            .bind(to: emailField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailMessageText
            .bind(to: emailField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Password
        
        viewModel.placeholder(textField: passwordField.inputTextField, "password_input_placeholder")
        
        viewModel.passwordInputTitle
            .bind(to: passwordField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordMessageText
            .bind(to: passwordField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Nickname
        
        viewModel.placeholder(textField: nicknameField.inputTextField, "nickname_input_placeholder")
        
        viewModel.nicknameInputTitle
                   .bind(to: nicknameField.fieldTitleLabel.rx.text)
                   .disposed(by: disposeBag)
        
        viewModel.nicknameMessageText
                 .bind(to: nicknameField.messageLabel.rx.text)
                 .disposed(by: disposeBag)
        
        viewModel.nicknameInputTitle
            .bind(to: nicknameField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func initialize() {
        setupBindings()
        
        //phoneNumberField.binding()
        //emailField.binding()
        //passwordField.binding()
        //nicknameField.binding()
    }
    
    // MARK: - Initialize
    
    init(viewModel: BasicInfoViewModelType = BasicInfoViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = BasicInfoViewModel()
        super.init(coder: aDecoder)
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
