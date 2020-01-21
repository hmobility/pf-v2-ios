//
//  ReseveTimeHelpGuideViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/08.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class TimeLabelGuideViewController: UIViewController {
    @IBOutlet weak var existingTimeLabel: UILabel!
    @IBOutlet weak var availableTimeLabel: UILabel!
    @IBOutlet weak var unavailableTimeLabel: UILabel!
    @IBOutlet weak var unavailableTimeDescLabel: UILabel!
    
    private let disposeBag = DisposeBag()

    private lazy var viewModel: CommonLabelGuideViewModelType = CommonLabelGuideViewModel()

    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.existingTimeText
            .drive(existingTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.availableTimeText
            .drive(existingTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.unavailableTimeText
            .drive(unavailableTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.unavailableTimeDescText
            .drive(unavailableTimeDescLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTapBinding() {
        self.view.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.dismissModal(animated: false)
        }
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
        setupTapBinding()
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
