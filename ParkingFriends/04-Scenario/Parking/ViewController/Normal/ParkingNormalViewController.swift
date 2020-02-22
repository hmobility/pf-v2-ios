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
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
  
    private var viewModel: ParkingStatusViewModelType?
    private var elapsedMinutes:BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
        
    private func setupParkingGuideBinding() {
        if let viewModel = viewModel {
            viewModel.getGuideText()
                .bind(to: self.guideLabel.rx.text)
                .disposed(by: disposeBag)
            
            viewModel.parkingStatusDescText
                .drive(self.descLabel.rx.text)
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Public Methods
    
    public func setViewModel(_ viewModel:ParkingStatusViewModelType) {
        self.viewModel = viewModel as? ParkingStatusViewModel
    }
    
    public func setElapsedTime(with minutes:Int) {
        elapsedMinutes.accept(minutes)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupParkingGuideBinding()
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
