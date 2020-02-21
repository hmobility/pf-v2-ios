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
    
    var backButtonAction: ((_ flag:Bool) -> Void)?
    var infoButtonAction: ((_ flag:Bool) -> Void)?
    
    private var viewModel: ParkingStatusViewModelType?
    private var elapsedMinutes:Int = 0
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        if let viewModel = viewModel {
            viewModel.viewTitleText
                .drive(self.navigationItem.rx.title)
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Public Methods
    
    public func setViewModel(_ viewModel:ParkingStatusViewModelType) {
        self.viewModel = viewModel as? ParkingStatusViewModel
    }
    
    public func setElapsedTime(with minutes:Int) {
          elapsedMinutes = minutes
      }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupNavigationBinding()
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
