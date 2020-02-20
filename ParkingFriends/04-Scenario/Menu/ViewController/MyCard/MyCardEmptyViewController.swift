//
//  NoCardViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension MyCardEmptyViewController: AnalyticsType {
    var screenName: String {
        return "[SCREEN] No Card View"
    }
}

class MyCardEmptyViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: EmptyCardViewModelType = EmptyCardViewModel()
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.noDataTitle
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.noDataDescription
            .drive(descriptionLabel.rx.text)
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
        setupBinding()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
