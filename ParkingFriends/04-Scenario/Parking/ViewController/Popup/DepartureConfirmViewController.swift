//
//  DeparturePopupViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/09.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

extension DepartureConfirmViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Departure w/ Extra Charge"
    }
}

class DepartureConfirmViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    private lazy var viewModel: DepartureConfirmViewModelType = DepartureConfirmViewModel()
    
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
