//
//  PhoneInputViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension PhoneNumberInputViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Input Phone Number"
    }
}

class PhoneNumberInputViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var fieldTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var sendButtonBottomConstraint: NSLayoutConstraint!
    
    private var viewModel: PhoneNumberViewModelType
    private let disposeBag = DisposeBag()
      
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismissRoot()
    }
    
    @IBAction func sendCodeButtonAction(_ sender: Any) {
      
    }
    
    // MARK: - Initialize

    init() {
        self.viewModel = PhoneNumberViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = PhoneNumberViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBindings()
        setupKeyboard()
        setupInputBinding()
        buttonBindings()
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
         viewModel.titleText
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
         
         viewModel.subtitleText
            .drive(subtitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.inputTitle
            .drive(fieldTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.inputPlaceholder
            .drive(inputTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.sendText
            .drive(sendButton.rx.title())
            .disposed(by: disposeBag)
    }

    private func setupKeyboard() {
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { height in
                self.sendButtonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.isHidden
            .distinctUntilChanged()
            .drive(onNext: { hidden in
                if hidden {
                    self.sendButtonBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupInputBinding() {
        inputTextField.delegate = viewModel.phoneNumberModel
    }
    
    private func buttonBindings() {
        sendButton.rx.tap
            .do(onNext: { [unowned self] in
                self.inputTextField.resignFirstResponder()
            })
            .subscribe(onNext: { [unowned self] status in
                self.viewModel.validateCredentials()
            })
            .disposed(by: disposeBag)
        
        viewModel.sendText.asDriver()
            .drive(self.sendButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.proceed.asDriver()
            .drive(onNext: { [unowned self] enabled in
                self.sendButton.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        viewModel.credential.asDriver().asDriver(onErrorJustReturn: (.none, nil))
            .drive(onNext: { [unowned self] (status, text) in
                if let message = text {
                    switch status {
                    case .sent:
                        MessageDialog.show(message, icon:.success)
                        self.navigateToCodeVerify(phoneNumber: self.inputTextField.text!)
                    case .invalid:
                        MessageDialog.show(message)
                    default:
                        break
                    }
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
    
    private func navigateToCodeVerify(phoneNumber:String) {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "CodeVerifyViewController") as! CodeVerifyViewController
        self.push(target)
    }

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
