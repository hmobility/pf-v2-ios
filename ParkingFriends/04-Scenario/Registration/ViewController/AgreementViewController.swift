//
//  AgreementViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension AgreementViewController : AnalyticsType {
    var screenName: String {
        return "Agreement Screen"
    }
}

class AgreementViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var locationServiceLabel: UILabel!
    @IBOutlet weak var thirdPartyInfoLabel: UILabel!
    @IBOutlet weak var marketingInfoLabel: UILabel!
    @IBOutlet weak var agreeAllLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet var mandatoryButtonList: [UIButton]!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
            
    private var viewModel: AgreementViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
     
     @IBAction func nextButtonAction(_ sender: Any) {
        navigateToRegiCar()
     }
    
    // MARK: - Initialize
    
    init(viewModel: AgreementViewModelType = AgreementViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = AgreementViewModel()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
      
    private func navigateToRegiCar() {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "RegiCarViewController") as! RegiCarViewController
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
