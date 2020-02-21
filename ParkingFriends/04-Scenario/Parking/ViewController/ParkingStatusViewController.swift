//
//  ParkingStatusViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension ParkingStatusViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Parking Status"
    }
}

class ParkingStatusViewController: UIViewController {
    private var embedNavigationController: UINavigationController?
    private var cctvViewController: ParkingCCTVPlayerViewController?
    private var normalViewController: ParkingNormalViewController?
    
    private var viewModel:ParkingStatusViewModelType = ParkingStatusViewModel()
    private var orderElement: OrderElement?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitleText
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupParkingStatusBinding() {
        viewModel.loadUsages()
        
        viewModel.getCctvStatus()
            .asObservable()
            .subscribe(onNext: { [unowned self] (supported:Bool, urls:[String], elapsedMinutes:Int) in
                if supported {
                    self.setupCCTVParkinglot(with: urls)
                } else {
                    self.setupNormalParkinglot(with: elapsedMinutes)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement) {
        viewModel.setOrderElement(element)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupParkingStatusBinding()
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        setNavigationBar(hidden: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setNavigationBar(hidden: false)
    }
    
    // MARK: - Local Methods
    
    private func setEmbedView(_ target:UIViewController) {
        if let navigationController = embedNavigationController {
            self.addChild(target)
            navigationController.viewControllers = [target]
            target.didMove(toParent: self)
        }
    }
    
    // MARK: - Navigation
    
    private func setupCCTVParkinglot(with urls:[String]) {
        let target = Storyboard.parking.instantiateViewController(withIdentifier: "ParkingCCTVPlayerViewController") as! ParkingCCTVPlayerViewController
        target.setViewModel(viewModel)
        target.setVideoUrls(with: urls)
        setEmbedView(target)
        
        target.backButtonAction = { flag in
            self.dismissRoot()
        }
    }
       
    private func setupNormalParkinglot(with elapsedMinutes:Int) {
        let target = Storyboard.parking.instantiateViewController(withIdentifier: "ParkingNormalViewController") as! ParkingNormalViewController
        target.setViewModel(viewModel)
        target.setElapsedTime(with: elapsedMinutes)
        setEmbedView(target)
        
        target.backButtonAction = { flag in
            self.dismissRoot()
        }
    }
       
    // MARK: Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ParkingStatusNavigation":
            guard let navigationController = segue.destination as? UINavigationController else {
                print("NavigationViewController is not generated."); return }
            self.embedNavigationController = navigationController
        default:
            break
        }
    }
}
