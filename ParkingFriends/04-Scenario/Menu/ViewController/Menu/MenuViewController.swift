//
//  MenuViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import SideMenu

extension MenuViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Side Menu"
    }
}

class MenuViewController: UIViewController {
    @IBOutlet weak var carSectionView:MenuCarSectionView!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userLevelButton: UIButton!
    @IBOutlet weak var userPointsLabel: UILabel!
    
    @IBOutlet weak var cardManagementView: UIView!
    @IBOutlet weak var cardManagementLabel: UILabel!
    @IBOutlet weak var pointChargeView: UIView!
    @IBOutlet weak var pointChargeLabel: UILabel!
    @IBOutlet weak var myCouponView: UIView!
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
    
    private var viewModel: MenuViewModelType = MenuViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding

    private func setupUserInfoBinding() {
        userLevelButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigateToLevelGuide()
            })
            .disposed(by: disposeBag)
        
        viewModel.getUserName()
            .asObservable()
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.getUserPoints()
            .asObservable()
            .bind(to: userPointsLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupCarSectionBinding() {
        viewModel.addNewCarText
            .drive(carSectionView.addNewCarLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.addCarText
            .drive(carSectionView.addCarButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.getUserCars()
            .map { return $0.first }
            .subscribe(onNext: { [unowned self] memberCar in
                if let carNumber = memberCar?.number {
                    self.carSectionView.setMyCarInfo(carNumber)
                }
            })
            .disposed(by: disposeBag)
        
        carSectionView.addNewCarButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        carSectionView.carListButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        carSectionView.addCarButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMiddleSectionBinding() {
        viewModel.cardManagementText
            .drive(cardManagementLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pointChargeText
            .drive(pointChargeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.myCouponText
            .drive(myCouponLabel.rx.text)
            .disposed(by: disposeBag)

        cardManagementView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.navigateToMyCard()
            }
            .disposed(by: disposeBag)
        
        pointChargeView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                
            }
            .disposed(by: disposeBag)
        
        myCouponView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func setupMenuBinding() {
        viewModel.paymentHistoryText
            .drive(paymentHistoryButton.rx.title())
            .disposed(by: disposeBag)
        
        paymentHistoryButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigateToHistory()
            })
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
        
        myInfoButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigateToMyInfo()
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
        setupCarSectionBinding()
        setupUserInfoBinding()
        setupMiddleSectionBinding()
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
    
    func navigateToHistory() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryNavigationController") as! UINavigationController
        self.modal(target, animated: true)
    }
    
    func navigateToSettings() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.modal(target)
    }
    
    func navigateToMyCard() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "MyCardNavigationController") as! UINavigationController
        self.modal(target)
    }
    
    func navigateToMyInfo() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "MyInfoNavigationController") as! UINavigationController
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
