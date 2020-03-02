//
//  PointViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension PointViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Point View"
    }
}

class PointViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usageButton: UIButton!
    
    private var viewModel: PointViewModelType = PointViewModel()
    
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
        
        usageButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.navigateToPointUsage()
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
     }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    
    // MARK: - Navigation
    
    
    private func navigateToPointUsage() {
        let target = Storyboard.detail.instantiateViewController(withIdentifier: "PointUsageViewController") as! ParkinglotDetailTimeLabelGuideViewController
        self.push(target)
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
