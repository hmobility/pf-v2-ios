//
//  ParkingNormalStatusViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension ParkingNormalViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Normal Parkinglot"
    }
}

class ParkingNormalViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var navigtationButton: UIButton!
    @IBOutlet weak var reserveExtensionButton: UIButton!
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var parkingInfoView: ParkingTicketInfoView!
  
    private var viewModel: ParkingStatusViewModelType = ParkingStatusViewModel()
    
    private let disposeBag = DisposeBag()
    
      // MARK: - Binding
      
    private func setupNavigationBinding() {
          viewModel.viewTitleText
            .drive(self.navigationBar.topItem!.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupParkingGuideBinding() {
        viewModel.getGuideText()
            .bind(to: self.guideLabel.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.parkingStatusDescText
            .drive(self.descLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupParkingStatusBinding() {
         viewModel.getUsagesItem()
             .asObservable()
             .subscribe(onNext: { [unowned self] usage in
                 self.updateScreenInfo(with: usage)
             })
             .disposed(by: disposeBag)
     }
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement) {
         viewModel.setOrderElement(element)
     }

    // MARK: - Local Methods
    
    private func updateScreenInfo(with usages:Usages) {
        parkingInfoView.setParkingInfo(with: usages)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupNavigationBinding()
        setupParkingGuideBinding()
        setupParkingStatusBinding()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
