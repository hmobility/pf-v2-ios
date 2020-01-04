//
//  MenuViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension MenuViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Side Menu"
    }
}

class MenuViewController: UIViewController {
    @IBOutlet weak var addMyCarLabel: UILabel!
    
    @IBOutlet weak var addNewCarButton: UIButton!
    @IBOutlet weak var addMyCarButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userLevelButton: UIButton!
    
    @IBOutlet weak var cardManagementLabel: UILabel!
    @IBOutlet weak var pointChargeLabel: UILabel!
    @IBOutlet weak var myCouponLabel: UILabel!
    
    @IBOutlet weak var paymentHistoryButton: UIButton!
    @IBOutlet weak var paymentCountButton: UIButton!
    @IBOutlet weak var myInfoButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var reportNewParkinglotButton: UIButton!
    @IBOutlet weak var shareMyParkinglotButton: UIButton!
    
    @IBOutlet weak var sideMenuView: UIView!
    
    private lazy var viewModel: MenuViewModelType = MenuViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding

    private func setupUserInfoBinding() {
        userLevelButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.navigateToLevelGuide()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMenuBinding() {
        viewModel.paymentHistoryText
            .drive(paymentHistoryButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.myInfoText
            .drive(myInfoButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.noticeText
            .drive(noticeButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.faqText
            .drive(faqButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.settingsText
            .drive(settingsButton.rx.title())
            .disposed(by: disposeBag)

        settingsButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigateToSettings()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupReportSectionBinding() {
        viewModel.reportNewParkinglotText
            .drive(reportNewParkinglotButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.shareMyParkinglotText
            .drive(shareMyParkinglotButton.rx.title())
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
        setupUserInfoBinding()
        setupMenuBinding()
        setupReportSectionBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation

    func navigateToLevelGuide() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "LevelGuideViewController") as! LevelGuideViewController
        
        self.modal(target, animated: true)
    }
    
    func navigateToSettings() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
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
