//
//  AgreementContentViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension AgreementContentViewController : AnalyticsType {
    var screenName: String {
        return "Registering Car Screen"
    }
}

class AgreementContentViewController: UIViewController {
    private var viewModel: RegiCarViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(viewModel: RegiCarViewModelType = RegiCarViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = RegiCarViewModel()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
