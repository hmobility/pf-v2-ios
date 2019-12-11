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
    @IBOutlet var marketingOptionButton: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
            
    private let disposeBag = DisposeBag()
    
    private var registrationModel: RegistrationModel = RegistrationModel.shared
    
    private lazy var viewModel: AgreementViewModelType = AgreementViewModel(registration:registrationModel)
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
     
    @IBAction func nextButtonAction(_ sender: Any) {
     //   navigateToRegiCar()
    }
    
    @IBAction func showAgreementAction(_ sender: Any) {
        let type = TermsType(rawValue: (sender as AnyObject).tag)!
        navigateToTerms(type)
    }
    
    @IBAction func checkButtontAction(_ sender: Any) {
        let index = checkButtonList.firstIndex(of: sender as! UIButton)!
        let result = !checkButtonList[index].isSelected
        checkButtonList[index].isSelected = result
        
        if result == false {
            selectAllButton.isSelected = false
        }
        
        updateCheckStatus()
    }
    
    @IBAction func selectAllButtontAction(_ sender: Any) {
        let checkButton = sender as! UIButton
        let result:Bool  = !checkButton.isSelected
        checkButton.isSelected = result
        
        checkButtonList.forEach { button in
            button.isSelected = result
        }
        
        marketingOptionButton.isSelected = result
        
        updateCheckStatus()
    }
    
    // MARK: - Local Methods
    
    private func updateCheckStatus() {
        var result:Bool = true
        
        for button in checkButtonList {
            print("[BUTTON]", button.isSelected)
            result = result && button.isSelected
        }
        
        viewModel.updateStatus(checkedAll: result)
    }
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBinding()
        setupButtonBinding()
    }
    
    // MARK: - Binding
    
    private func getAttributedString(_ text:String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
           attributes:[NSAttributedString.Key.foregroundColor: Color.darkGrey,
                       NSAttributedString.Key.underlineStyle:1.0,
                       NSAttributedString.Key.font: Font.gothicNeoRegular15])
    }
    
    private func setupBinding() {
        // Usage

        viewModel.usageText
            .map({ [unowned self] text in
                return self.getAttributedString(text)
            })
            .drive(usageButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.personalInfoText
            .map({  [unowned self] text in
                return self.getAttributedString(text)
            })
            .drive(personalInfoButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.locationServiceText
            .map({  [unowned self] text in
                return self.getAttributedString(text)
            })
            .drive(locationServiceButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.thirdPartyText
            .map({ [unowned self] text in
                return self.getAttributedString(text)
            })
            .drive(thirdPartyInfoButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.marketingInfoText
            .map({ [unowned self] text in
                return self.getAttributedString(text)
            })
            .drive(marketingInfoButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        viewModel.sentenceText ~> [usageLabel, personalInfoLabel, locationServiceLabel, thirdPartyInfoLabel, marketingInfoLabel]
            .map { $0.rx.text }
            ~ disposeBag
        
        viewModel.agreeAllText
            .drive(agreeAllLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.agreementOptionText
            .drive(optionLabel.rx.text)
            .disposed(by: disposeBag)
    }
  
    private func setupButtonBinding() {
        viewModel.proceed.asDriver()
            .drive(onNext: { [unowned self] (completed) in
                debugPrint("[PROCEED] check all : ", completed)
                self.nextButton.isEnabled = completed ? true : false
            })
            .disposed(by: disposeBag)
        
        marketingOptionButton.rx.tap
            .asObservable()
            .map { (_) -> Bool in
                return !self.marketingOptionButton.isSelected
            }
            .subscribe(onNext: { (isSelected) in
                self.marketingOptionButton.isSelected = isSelected
                self.viewModel.setAgreeWithThirdParty(check: isSelected)
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                //let selected = self.marketingOptionButton.isSelected
               // self.viewModel.setAgreeWithThirdParty(check: selected)
                self.viewModel.requestSignup { success in
                    if success {
                        self.navigateToRegiCar()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
