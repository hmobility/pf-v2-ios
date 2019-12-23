//
//  RegiCreditCardViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension RegiCreditCardViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Registering Credit Card"
    }
}

class RegiCreditCardViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var cardNumberField: CustomInputSection!
    @IBOutlet weak var expirationDateField: CustomInputSection!
    @IBOutlet weak var passwordTwoDigitsNumberField: CustomInputSection!
    @IBOutlet weak var residentNumberField: CustomInputSection!
    @IBOutlet weak var holderNameField: CustomInputSection!
    
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var registrationModel: RegistrationModel = RegistrationModel.shared
    
    private lazy var viewModel: RegiCreditCardViewModelType = RegiCreditCardViewModel(registration:registrationModel)
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigateToTutorial()
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
        setupCardNumberBidning()
        setupExpirationDateBidning()
        setupPasswordTwoDigitsBidning()
        setupResidentNumberBidning()
        setupHolderNameBidning()
        setupKeyboard()
        setupButtonBinding()
    }
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitle
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupCardNumberBidning() {
        viewModel.cardNumberInputTitle
            .drive(cardNumberField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cardNumberInputPlaceholder
            .drive(cardNumberField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.cardNumberMessageText
            .asDriver()
            .drive(cardNumberField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        cardNumberField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section: .number)
            })
            .disposed(by: disposeBag)
    
        let inputEvents:Observable<Bool> = Observable.merge([
            cardNumberField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
            cardNumberField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
        ])
        
        inputEvents.asObservable()
            .subscribe(onNext: { editing in
                _ = self.viewModel.validateCredentials(section:.number, editing:editing)
            })
            .disposed(by: disposeBag)

        cardNumberField.inputTextField.rx.shouldChangeCharactersIn
            .asObservable()
            .subscribe(onNext: { (textfield, range, text) in
                self.viewModel.formatted(section:.number, textField:textfield, range:range, replacement: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupExpirationDateBidning() {
        viewModel.expirationDateInputTitle
            .drive(expirationDateField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.expirationDateInputPlaceholder
            .drive(expirationDateField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.expirationDateMessageText
            .asDriver()
            .drive(expirationDateField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        expirationDateField.inputTextField.rx.text
             .orEmpty
             .asDriver()
             .drive(onNext: { [unowned self] text in
                 self.viewModel.accept(text, section: .expiration_date)
             })
             .disposed(by: disposeBag)
        
        let inputEvents:Observable<Bool> = Observable.merge([
             expirationDateField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
             expirationDateField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
         ])
         
         inputEvents.asObservable()
             .subscribe(onNext: { editing in
                 _ = self.viewModel.validateCredentials(section:.expiration_date, editing:editing)
             })
             .disposed(by: disposeBag)
        
        expirationDateField.inputTextField.rx.shouldChangeCharactersIn
            .asObservable()
            .subscribe(onNext: { (textfield, range, text) in
                self.viewModel.formatted(section:.expiration_date, textField:textfield, range:range, replacement: text)
            })
            .disposed(by: disposeBag)
     }
    
    private func setupPasswordTwoDigitsBidning() {
        viewModel.passwordTwoDigitsInputTitle
            .drive(passwordTwoDigitsNumberField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordTwoDigitsInputPlaceholder
            .drive(passwordTwoDigitsNumberField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.passwordTwoDigitsMessageText
             .asDriver()
             .drive(passwordTwoDigitsNumberField.messageLabel.rx.text)
             .disposed(by: disposeBag)
        
        passwordTwoDigitsNumberField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section:.password)
            })
            .disposed(by: disposeBag)
        
        let inputEvents:Observable<Bool> = Observable.merge([
             passwordTwoDigitsNumberField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
             passwordTwoDigitsNumberField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
         ])
         
         inputEvents.asObservable()
             .subscribe(onNext: { editing in
                 _ = self.viewModel.validateCredentials(section:.password, editing:editing)
             })
             .disposed(by: disposeBag)
    }
    
    private func setupResidentNumberBidning() {
        viewModel.residentNumberInputTitle
            .drive(residentNumberField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.residentNumberInputPlaceholder
            .drive(residentNumberField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.residentNumberMessageText
            .asDriver()
            .drive(residentNumberField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        residentNumberField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section:.resident_number)
            })
            .disposed(by: disposeBag)
        
        let inputEvents:Observable<Bool> = Observable.merge([
            residentNumberField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
            residentNumberField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
        ])
        
        inputEvents.asObservable()
            .subscribe(onNext: { editing in
                _ = self.viewModel.validateCredentials(section:.resident_number, editing:editing)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupHolderNameBidning() {
        viewModel.holderNameInputTitle
            .drive(holderNameField.fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.holderNameInputPlaceholder
            .drive(holderNameField.inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.holderNameMessageText
            .asDriver()
            .drive(holderNameField.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        holderNameField.inputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.viewModel.accept(text, section:.holder_name)
            })
            .disposed(by: disposeBag)
        
        let inputEvents:Observable<Bool> = Observable.merge([
            holderNameField.inputTextField.rx.controlEvent([.editingChanged, .valueChanged]).map { true },
            holderNameField.inputTextField.rx.controlEvent([.editingDidEnd]).map { false }
        ])
        
        inputEvents.asObservable()
            .subscribe(onNext: { editing in
                _ = self.viewModel.validateCredentials(section:.holder_name, editing:editing)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { height in
                self.nextButtonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
                self.scrollView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        skipButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToTutorial()
            })
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.requestRegisterCard()
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
                    self.navigateToTutorial()
                case .failure:
                    MessageDialog.show(message)
                    break
                }
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
    
    private func navigateToTutorial() {
        let target = Storyboard.tutorial.instantiateInitialViewController() as! UINavigationController
        self.modal(target)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
