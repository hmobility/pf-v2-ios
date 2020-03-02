//
//  ParkingCamViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/25.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension ParkingCamViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] CCTV Parkinglot Player"
    }
}

class ParkingCamViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cctvScreenView: ParkingCamScreenView!
    
    @IBOutlet weak var parkingInfoView: ParkingTicketInfoView!
   
    @IBOutlet weak var guideLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var directionGuideButton: UIButton!
    @IBOutlet weak var reserveExtensionButton: UIButton!
    
    private var viewModel: ParkingStatusViewModelType = ParkingStatusViewModel()
    private var cctvGroupName:String?
    private var orderElement: OrderElement?
    
    private let disposeBag = DisposeBag()

    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitleText
            .drive(self.navigationBar.topItem!.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupBinding() {
        viewModel.departueText
            .asDriver()
            .drive(directionGuideButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.reserveExtensionText
            .asDriver()
            .drive(reserveExtensionButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.directionGuideText
            .asDriver()
            .drive(directionGuideButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupParkingStatusBinding() {
        viewModel.getGuideText()
            .bind(to: self.guideLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.getUsagesItem()
            .asObservable()
            .subscribe(onNext: { [unowned self] usage in
                self.updateScreenInfo(with: usage)
            })
            .disposed(by: disposeBag)
        
        viewModel.getCameraList()
            .asObservable()
            .subscribe(onNext: {  [unowned self] cameraList in
                self.updateCamInfo(cameraList)
            })
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
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement) {
        viewModel.setOrderElement(element)
    }
    
    // MARK: - Local Methods
    
    private func updateCamInfo(_ items:[CamElement]) {
        cctvScreenView.setCameraList(items)
    }
    
    private func updateScreenInfo(with usages:Usages) {
        usages.cctvGroupName = "AT59459"
        parkingInfoView.setParkingInfo(with: usages)
    }

    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
        setupNavigationBinding()
        setupButtonBinding()
        setupParkingStatusBinding()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cctvScreenView.destroyPlayer()
    }
    
    // MARK: Naviagtion
    
    private func navigateToDataUsagePopup() {
        let target = Storyboard.parking.instantiateViewController(withIdentifier: "PaymentDataUsageViewController") as! PaymentDataUsageViewController
        
        target.selectAction = { flag in
            
        }
        
        self.modal(target, transparent: true, animated: false)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
