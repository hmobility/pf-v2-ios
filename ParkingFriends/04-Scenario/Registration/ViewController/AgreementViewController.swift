//
//  AgreementViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import ActiveLabel

extension AgreementViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Agreement"
    }
}

class AgreementViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var usageButton: UIButton!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var personalInfoButton: UIButton!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var locationServiceButton: UIButton!
    @IBOutlet weak var locationServiceLabel: UILabel!
    @IBOutlet weak var thirdPartyInfoButton: UIButton!
    @IBOutlet weak var thirdPartyInfoLabel: UILabel!
    @IBOutlet weak var marketingInfoButton: UIButton!
    @IBOutlet weak var marketingInfoLabel: UILabel!
    @IBOutlet weak var agreeAllLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet var checkButtonList: [UIButton]!
    @IBOutlet weak var selectAllButton: UIButton!
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
    
    @IBAction func showAgreementAction(_ sender: Any) {
        let type = TermsType(rawValue: (sender as AnyObject).tag)!
        navigateToTerms(type)
    }
    
    @IBAction func checkButtontAction(_ sender: Any) {
        let index = checkButtonList.firstIndex(of: sender as! UIButton)!
      //  let index = (sender as AnyObject).tag as Int
        let result = !checkButtonList[index].isSelected
        checkButtonList[index].isSelected = result
        
        if result == false {
            selectAllButton.isSelected = false
        }
    }
    
    @IBAction func selectAllButtontAction(_ sender: Any) {
        let checkButton = sender as! UIButton
        let result:Bool  = !checkButton.isSelected
        checkButton.isSelected = result
        
        checkButtonList.forEach { button in
            button.isSelected = result
        }
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        // Usage
        
        viewModel.usageText
            .bind(to: usageButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.personalInfoText
            .bind(to: personalInfoButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.locationServiceText
            .bind(to: locationServiceButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.thirdPartyText
            .bind(to: thirdPartyInfoButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.marketingInfoText
            .bind(to: marketingInfoButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.sentenceText ~> [usageLabel, personalInfoLabel, locationServiceLabel, thirdPartyInfoLabel, marketingInfoLabel]
            .map { $0.rx.text }
            ~ disposeBag
        
        viewModel.agreeAllText
            .bind(to: agreeAllLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.agreementOptionText
            .bind(to : optionLabel.rx.text)
            .disposed(by: disposeBag)
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
        setupBindings()
    }
    
    // MARK: - Navigation
      
    private func navigateToRegiCar() {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "RegiCarViewController") as! RegiCarViewController
        self.push(target)
    }
    
    private func navigateToTerms(_ type:TermsType) {
        let target = Storyboard.terms.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        target.setTermsType(type)
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
