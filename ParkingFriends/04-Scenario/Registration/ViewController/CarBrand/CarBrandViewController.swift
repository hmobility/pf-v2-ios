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
    
    @IBOutlet weak var carBrandTableView: UITableView!
    @IBOutlet weak var carModelTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
            
    @IBOutlet weak var selectedCarFieldLabel: UILabel!
    @IBOutlet weak var selectedCarLabel: UILabel!
    
    private var viewModel: CarBrandViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        // self.dismiss(animated: true)
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
        setupButtonBinding()
    }
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitleText
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.closeText
            .drive(self.closeButton.rx.title())
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
    
    private func setupButtonBinding() {
        closeButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissModal()
            })
            .disposed(by: disposeBag)
        
        viewModel.proceed.asDriver()
            .drive(onNext: { [unowned self] flag in
                self.nextButton.isEnabled = flag ? true : false
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func fetchBrands() {
        viewModel.brandItems
            .bind(to:carBrandTableView.rx.items(cellIdentifier: "CarBrandTableViewCell", cellType: CarBrandTableViewCell.self)) { row , item, cell in
                cell.setBrand(item.name)
            }
            .disposed(by: disposeBag)
        
        viewModel.loadMakerList()
    }
    
    private func fetchCarModels() {
        /*
        carBrandTableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { indexPath in
                self.viewModel.loadModels(idx: indexPath.row)
            })
        .disposed(by: disposeBag)
        */
        viewModel.modelItems
            .bind(to: carModelTableView.rx.items(cellIdentifier: "CarModelTableViewCell", cellType: CarModelTableViewCell.self)) { row , item, cell in
                cell.setModel(item.name)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        fetchBrands()
        fetchCarModels()
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
