//
//  PhoneInputViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension PhoneInputViewController : AnalyticsType {
    var screenName: String {
        return "Phone Input Screen"
    }
}

class PhoneInputViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var fieldTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!

    private var viewModel: EntryViewModelType
    private let disposeBag = DisposeBag()
      
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func sendCodeButtonAction(_ sender: Any) {
        navigateToCodeVerify()
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBindings()
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        /*
         viewModel.loginText
         .bind(to: loginButton.rx.title(for: .normal))
         .disposed(by: disposeBag)
         
         viewModel.signupText
         .bind(to: signupButton.rx.title(for: .normal))
         .disposed(by: disposeBag)
         
         viewModel.signupGuideText
         .bind(to: signupGuideLabel.rx.text)
         .disposed(by: disposeBag)
         */
    }
    
    // MARK: - Life Cycle
    
    init() {
        self.viewModel = EntryViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = EntryViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    private func navigateToCodeVerify() {
        let codeVerify = Storyboard.registration.instantiateViewController(withIdentifier: "CodeVerifyViewController") as! CodeVerifyViewController
        self.push(codeVerify)
    }

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
