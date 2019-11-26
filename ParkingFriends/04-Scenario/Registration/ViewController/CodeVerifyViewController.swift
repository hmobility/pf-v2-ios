//
//  PhoneVerifyViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class CodeVerifyViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var fieldTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    private var viewModel: CodeVerifyViewModelType
    private let disposeBag = DisposeBag()

    // MARK: - Button Action
     
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigateToBasicInfoInput()
    }
    
    // MARK: - Initialize
    
    init() {
        self.viewModel = CodeVerifyViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = CodeVerifyViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBindings()
        setupKeyboard()
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
        
        viewModel.nextText
            .drive(nextButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboard() {
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { height in
                self.nextButtonBottomConstraint.constant = height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.isHidden
            .distinctUntilChanged()
            .drive(onNext: { hidden in
                if hidden {
                    self.nextButtonBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
      
    private func navigateToBasicInfoInput() {
        let basicInfoInput = Storyboard.registration.instantiateViewController(withIdentifier: "BasicInfoInputViewController") as! BasicInfoInputViewController
        self.push(basicInfoInput)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
