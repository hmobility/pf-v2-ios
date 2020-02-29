//
//  PointUsageViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension PointUsageViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Point Usage View"
    }
}

class PointUsageViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    private var viewModel: PointUsageViewModelType = PointUsageViewModel()
    
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
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
