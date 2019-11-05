//
//  LoginViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension LoginViewController : AnalyticsType {
    var screenName: String {
        return "Login Screen"
    }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var changeCellNumberButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    private var viewModel: LoginViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action

    @IBAction func changeCellNumberButtonAction(_ sender: Any) {
    }
    
    @IBAction func findPasswordButtonAction(_ sender: Any) {
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
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
        
        viewModel.changeCellNumberText
            .bind(to: changeCellNumberButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.findPaswordText
            .bind(to: findPasswordButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
 */
    }
    
    // MARK: - Life Cycle
    
    init() {
        self.viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = LoginViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
