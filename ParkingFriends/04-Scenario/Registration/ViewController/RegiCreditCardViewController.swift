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
        return "Registering Credit Card Screen"
    }
}

class RegiCreditCardViewController: UIViewController {
    
    private var viewModel: RegiCreditCardViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigateToGuide()
    }
    
    // MARK: - Initialize
    
    init(viewModel: RegiCreditCardViewModelType = RegiCreditCardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = RegiCreditCardViewModel()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    private func navigateToGuide() {
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
