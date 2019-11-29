//
//  RegisteringCarViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension RegiCarViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Registering Car Info"
    }
}

class RegiCarViewController: UIViewController {
    
    private var viewModel: RegiCarViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigateToRegiCreditCard()
    }
        
    // MARK: - Initialize
    
    init(viewModel: RegiCarViewModelType = RegiCarViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = RegiCarViewModel()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    private func navigateToRegiCreditCard() {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "RegiCreditCardViewController") as! RegiCreditCardViewController
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
