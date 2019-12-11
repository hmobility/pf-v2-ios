//
//  RegisteringCarViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension RegiCarViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Registering Car Info"
    }
}

class RegiCarViewController: UIViewController {
    @IBOutlet weak var skipButton: UIBarButtonItem!
    @IBOutlet weak var selectCarButton: UIButton!
    @IBOutlet weak var selectColorButton: UIButton!
    private var viewModel: RegiCarViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigateToRegiCar()
    }
        
    // MARK: - Initialize
    
    init(viewModel: RegiCarViewModelType = RegiCarViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = RegiCarViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupButtonBinding()
    }
    
    // MARK: - Binding
    
    private func setupButtonBinding() {
        selectCarButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToRegiCar()
            })
            .disposed(by: disposeBag)
        
        selectColorButton.rx.tap
            .subscribe(onNext: { _ in
                self.showColorDiaglog()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
    
    private func navigateToRegiCar() {
        let target = Storyboard.registration.instantiateViewController(withIdentifier: "CarInfoSearchNavigationController") as! UINavigationController
        self.modal(target)
    }
    
    private func showColorDiaglog() {
        ColorDialog.show { (finished, color) in
            if finished {
                print("[SEL COLOR] ", color)
            }
        }
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
