//
//  ParkinglotListViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import PullUpController

extension ParkinglotTapViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Parkinglot Tap"
    }
}

class ParkinglotTapViewController: PullUpController {
 
    @IBOutlet weak var timeTicketButton: UIButton!
    @IBOutlet weak var fixedTicketButton: UIButton!
    @IBOutlet weak var monthlyTicketButton: UIButton!

    @IBOutlet weak var sortOrderButton: UIButton!
    
    private let disposeBag = DisposeBag()

    private lazy var viewModel: ParkinglotTapViewModelType = ParkinglotTapViewModel()
    
    // MARK: - Binding
    
    private func setupBindings() {
        viewModel.timeTicketText
            .drive(timeTicketButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.fixedTicketText
            .drive(fixedTicketButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.monthlyTicketText
            .drive(monthlyTicketButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupTapButtonBinding() {
        
        viewModel.selectedProductType.asDriver()
            /*
            .do(onNext: { type in
                self.timeTicketButton.isSelected = (type == .time) ? true : false
                self.fixedTicketButton.isSelected = (type == .fixed) ? true : false
                self.monthlyTicketButton.isSelected = (type == .monthly) ? true : false
            })*/
            .drive(onNext: { type in
                self.timeTicketButton.isSelected = (type == .time) ? true : false
                self.fixedTicketButton.isSelected = (type == .fixed) ? true : false
                self.monthlyTicketButton.isSelected = (type == .monthly) ? true : false
            })
            .disposed(by: disposeBag)
        
        let observable = Observable.merge (
            timeTicketButton.rx.tap.map { return ProductType.time},
            fixedTicketButton.rx.tap.map { return ProductType.fixed},
            monthlyTicketButton.rx.tap.map { return ProductType.monthly}
        )
        
        observable.asObservable()
            .subscribe(onNext: { type in
                self.viewModel.setProductType(type)
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
        setupBindings()
        setupTapButtonBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
