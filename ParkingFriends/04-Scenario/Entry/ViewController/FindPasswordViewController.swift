//
//  FindPasswordViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension FindPasswordViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Find Password"
    }
}

class FindPasswordViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var fieldTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var confirmButtonBottomConstraint: NSLayoutConstraint!
    
    private var viewModel: FindPasswordViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismissRoot()
    }
    
    // MARK: - Initialize
    
    init() {
        self.viewModel = FindPasswordViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = FindPasswordViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBindings()
        setupKeyboard()
        buttonBindings()
        inputBindings()
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
        
        viewModel.confirmText
            .bind(to: confirmButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func buttonBindings() {
        confirmButton.rx.tap.do(onNext: { [unowned self] in
                self.inputTextField.resignFirstResponder()
            })
            .map({
                self.viewModel.credential.value
            })
            .subscribe(onNext: { [unowned self] status in
                if status == .valid {
                    if let text = self.inputTextField.text {
                        self.viewModel.sendVerification(email: text, type: .phone)
                    }
                } 
            }).disposed(by: disposeBag)
        
        /*
        viewModel.credential.asDriver().asDriver(onErrorJustReturn: .none)
            .drive(onNext: { [unowned self] status in
                switch status {
                case .none:
                    self.confirmButton.isEnabled = false
                case .valid:
                    self.confirmButton.isEnabled = true
                case .sent:
                    self.confirmButton.isEnabled = true
                    self.dismissRoot {
                        MessageDialog.show(self.viewModel.message(.sent), icon:.success)
                    }
                case .invalid:
                    self.confirmButton.isEnabled = true
                    MessageDialog.show(self.viewModel.message(.invalid))
                }
            })
            .disposed(by: disposeBag)
 */
    }
       
    
    private func inputBindings() {
         inputTextField.rx.text
             .orEmpty
             .asDriver()
             .asObservable()
             .subscribe(onNext: { text in
                 let result = text.validatePattern(type: .email)
                 self.viewModel.updateStatus(result ? .valid : .none)
             })
             .disposed(by: disposeBag)
     }
     
     private func setupKeyboard() {
         RxKeyboard.instance.willShowVisibleHeight
             .drive(onNext: { height in
                 self.confirmButtonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                 self.view.layoutIfNeeded()
             })
            .disposed(by: disposeBag)
         
         RxKeyboard.instance.isHidden
             .distinctUntilChanged()
             .drive(onNext: { hidden in
                 if hidden {
                     self.confirmButtonBottomConstraint.constant = 0
                     self.view.layoutIfNeeded()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
