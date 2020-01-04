//
//  SettingsViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension SettingsViewController: AnalyticsType {
    var screenName: String {
        return "[SCREEN] Settings"
    }
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var pushSectionTitleLabel: UILabel!
    @IBOutlet weak var pushAgreementTitleLabel: UILabel!
    @IBOutlet weak var pushAgreementDescLabel: UILabel!
    @IBOutlet weak var pushOnOffSwitch: UISwitch!
    
    @IBOutlet weak var pushInGoingTitleLabel: UILabel!
    @IBOutlet weak var pushInGoingButton: UIButton!
    @IBOutlet weak var pushOutGoingTitleLabel: UILabel!
    @IBOutlet weak var pushOutGoingButton: UIButton!
    
    @IBOutlet weak var voiceRecognitionSectionTitleLabel: UILabel!
    @IBOutlet weak var voiceRecognitionTitleLabel: UILabel!
    @IBOutlet weak var voiceRecognitionDescLabel: UILabel!
    @IBOutlet weak var voiceRecognitionOnOffSwitch: UISwitch!
    
    @IBOutlet weak var termsAndPoliciesSectionTitleLabel: UILabel!
    @IBOutlet weak var usageTitleLabel: UILabel!
    @IBOutlet weak var usageButton: UIButton!
    
    @IBOutlet weak var personalInfoTitleLabel: UILabel!
    @IBOutlet weak var personalInfoButton: UIButton!
    
    @IBOutlet weak var locationServiceTitleLabel: UILabel!
    @IBOutlet weak var locationServiceButton: UIButton!
  
    @IBOutlet weak var appVersionSectionTitleLabel: UILabel!
    @IBOutlet weak var appVersionTitleLabel: UILabel!
    @IBOutlet weak var appVersionButton: UIButton!
    
    @IBOutlet weak var existSectionTitleLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var withdrawTitleLabel: UILabel!
    @IBOutlet weak var withdrawButton: UIButton!
    
    @IBOutlet weak var creditLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIButton!
    
    private let disposeBag = DisposeBag()

    private lazy var viewModel: SettingsViewModelType = SettingsViewModel()
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        if let topItem = navigationBar.topItem {
            viewModel.viewTitle
                .drive(topItem.rx.title)
                .disposed(by: disposeBag)
        }
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.pop()
                self.dismissModal()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPushBinding() {
        viewModel.pushSectionTitle
            .drive(pushSectionTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pushFieldText
            .drive(pushAgreementTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pushDescText
            .drive(pushAgreementDescLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pushOnOff.asObservable()
            .bind(to: pushOnOffSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    private func setupVoiceBinding() {
        viewModel.voiceRecognitionSectionTitle
            .drive(voiceRecognitionSectionTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.voiceRecognitionFieldText
            .drive(voiceRecognitionTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.voiceRecognitionDescText
            .drive(voiceRecognitionDescLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.voiceRecognitionOnOff
            .asObservable()
            .bind(to: voiceRecognitionOnOffSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    private func setupTermsAndPoliciesBinding() {
        viewModel.termsAndPoliciesSectionTitle
            .drive(termsAndPoliciesSectionTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.usageFieldText
            .drive(usageTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.personalInfoFieldText
            .drive(personalInfoTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.locationServiceFieldText
            .drive(locationServiceTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupAppInfoBinding() {
         viewModel.appInfoSectionTitle
             .drive(appVersionSectionTitleLabel.rx.text)
             .disposed(by: disposeBag)
         
         viewModel.appVersionFieldText
             .drive(appVersionTitleLabel.rx.text)
             .disposed(by: disposeBag)
        
        viewModel.appDisplayVersionText
            .drive(appVersionButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupExitBinding() {
        viewModel.exitSectionTitle
            .drive(existSectionTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.logoutFieldText
            .drive(logoutButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.withdrawFieldText
            .drive(withdrawButton.rx.title())
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                let message = self.viewModel.logoutMessage()
                self.logoutPopup(message.title, desc:message.message, done:message.done, cancel:message.cancel)
              //  self.showSortOrderDiaglog()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCreditBinding() {
        viewModel.creditText
            .drive(creditLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func logoutPopup(_ title:String, desc:String, done:String, cancel:String) {
        self.alert(title: desc, actions: [AlertAction(title: done, type: 0, style: .default), AlertAction(title: cancel, type: 1, style: .cancel)])
            .asObservable()
            .subscribe(onNext: { index in
                if index == 0 {
                    debugPrint("Exist")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupNavigationBinding()
        setupPushBinding()
        setupVoiceBinding()
        setupTermsAndPoliciesBinding()
        setupAppInfoBinding()
        setupExitBinding()
        setupCreditBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
