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
    @IBOutlet weak var migrationButton: UIButton!
    
    private var viewModel: EntryViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func loginButtonAction(_ sender: Any) {
       // navigateToLogin()
       
        navigateToMain()
        
        self.trackLog()
        self.track("gender", forName:"female")
        self.track("location", forName:"parking")
        self.track("parking", forName:"unknown")
        self.track("male", forName:"gender")
        self.track("gender=male", forName:"gender")
        self.track("dev", ["p1": "open"])
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        navigateToSignup()
    }
    
    @IBAction func migrationButtonAction(_ sender: Any) {

    }
    
    // MARK: - Initialize

    private func initialize() {
        setupBindings()
    }
    
    // MARK: - Binding

    private func setupBindings() {
        viewModel.loginText
            .drive(loginButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.signupText
            .drive(signupButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.signupGuideText
            .drive(signupGuideLabel.rx.text)
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
    
    private func navigateToMain() {
        let target = Storyboard.main.instantiateInitialViewController() as! UINavigationController
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
