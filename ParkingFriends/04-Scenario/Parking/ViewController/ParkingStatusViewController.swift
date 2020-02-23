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
    @IBOutlet weak var parkingInfoView: ParkingTicketInfoView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
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
    
    private func setupButtonBinding() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismissRoot()
            })
            .disposed(by: disposeBag)
        
        infoButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismissRoot()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupParkingStatusBinding() {
        viewModel.getParkingStatus()
            .asObservable()
            .subscribe(onNext: { [unowned self] itemInfo in
                self.updateScreenInfo(with: itemInfo)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement) {
        viewModel.setOrderElement(element)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupNavigationBinding()
        setupButtonBinding()
        setupParkingStatusBinding()
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
     //   setNavigationBar(hidden: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     //   setNavigationBar(hidden: false)
    }
    
    // MARK: - Local Methods
    
    private func updateScreenInfo(with usages:Usages) {
        let urls = usages.camIds
        let elapsedMinutes = usages.elapsedMinutes
    
        if urls.count > 0 {
            self.setupCCTVParkinglot(with: urls)
        } else {
            self.setupNormalParkinglot(with: elapsedMinutes)
        }
        
        parkingInfoView.setParkingInfo(with: usages)
    }
    
    private func setEmbedView(_ target:UIViewController) {
        if let navigationController = embedNavigationController {
            self.addChild(target)
            navigationController.viewControllers = [target]
            target.didMove(toParent: self)
        }
    }
    
    // MARK: - Setup CCTV
    
    private func setCCTVNavigationStyle() {
        if let navigationBar =  self.navigationController?.navigationBar {
            backButton.tintColor = Color.darkGrey
            backButton.backgroundColor = UIColor.white
            infoButton.backgroundColor = UIColor.white
            backButton.tintColor = Color.darkGrey
            navigationBar.backgroundColor = UIColor.white
        }
    }
    
    private func setupCCTVParkinglot(with urls:[String]) {
        let target = Storyboard.parking.instantiateViewController(withIdentifier: "ParkingCCTVPlayerViewController") as! ParkingCCTVPlayerViewController
        target.setViewModel(viewModel)
        target.setVideoUrls(with: urls)
        
        setCCTVNavigationStyle()
        
        setEmbedView(target)
    }
    
    // MARK: - Setup Normal
    
    private func setNormalNavigationStyle() {
        if let navigationBar = self.navigationController?.navigationBar, let navigationController = self.navigationController {
            backButton.tintColor = UIColor.white
            infoButton.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationBar.barTintColor = Color.algaeGreen
            navigationBar.shadowImage = UIImage(named: "imgPixel")
            (navigationController as! ParkingStatusNavigationController).statusBarStyle = .lightContent
        }
    }
       
    private func setupNormalParkinglot(with elapsedMinutes:Int) {
        let target = Storyboard.parking.instantiateViewController(withIdentifier: "ParkingNormalViewController") as! ParkingNormalViewController
    
        target.setViewModel(viewModel)
        target.setElapsedTime(with: elapsedMinutes)
        
        setNormalNavigationStyle()
        
        setEmbedView(target)
    }

    // MARK: - Prepare
    
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
