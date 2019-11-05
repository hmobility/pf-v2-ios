//
//  EntryViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension EntryViewController : AnalyticsType {
    var screenName: String {
        return "Entry Screen"
    }
}

class EntryViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupGuideLabel: UILabel!
    
    private var viewModel: EntryViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func loginButtonAction(_ sender: Any) {
        navigateToLogin()
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        navigateToSignup()
    }
    // MARK: - Initialize

    private func initialize() {
        setupBindings()
    }
    
    // MARK: - Binding

    private func setupBindings() {
        viewModel.loginText
            .bind(to: loginButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.signupText
            .bind(to: signupButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.signupGuideText
            .bind(to: signupGuideLabel.rx.text)
            .disposed(by: disposeBag)
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
        initialize()
    }
    
    // MARK: - Navigation
    
    private func navigateToLogin() {
        let target = Storyboard.entry.instantiateViewController(withIdentifier: "LoginViewController")
        self.push(target)
    }
    
    private func navigateToSignup() {
        let target = Storyboard.registration.instantiateInitialViewController() as! UINavigationController
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
