//
//  CarBrandViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension CarBrandViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Car Brand Selection"
    }
}

class CarBrandViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
            
    @IBOutlet weak var selectedCarFieldLabel: UILabel!
    @IBOutlet weak var selectedCarLabel: UILabel!
    
    private var viewModel: CarBrandViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        // navigateToBasicInfoInput()
    }
    
    // MARK: - Initialize
    
    init(viewModel: CarBrandViewModelType = CarBrandViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = CarBrandViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupNavigationBinding()
        setupBinding()
        setupInputBinding()
    }
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitleText
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.closeText
            .drive(self.backButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupBinding() {
        viewModel.nextText
            .drive(self.nextButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.selectedCarFieldText
            .drive(self.selectedCarFieldLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupInputBinding() {
         viewModel.selectedCarText
            .asDriver()
            .drive(self.selectedCarLabel.rx.text)
            .disposed(by: disposeBag)
     }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
