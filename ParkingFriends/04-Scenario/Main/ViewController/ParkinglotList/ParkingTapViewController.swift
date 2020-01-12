//
//  ParkinglotListViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension ParkingTapViewController: AnalyticsType {
    var screenName: String {
        return "[SCREEN] Parkinglot Tap"
    }
}

class ParkingTapViewController: UIViewController {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var dataView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var timeTicketButton: UIButton!
    @IBOutlet weak var fixedTicketButton: UIButton!
    @IBOutlet weak var monthlyTicketButton: UIButton!

    @IBOutlet weak var sortOrderButton: UIButton!
    
    private let disposeBag = DisposeBag()

    private lazy var viewModel: ParkingTapViewModelType = ParkingTapViewModel()
    
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
        
        viewModel.sortOrderText.asDriver()
            .drive(sortOrderButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setupTapButtonBinding() {
        viewModel.selectedProductType
            .asDriver()
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
    
    private func setupSortOrderButtonBinding() {
        sortOrderButton.rx.tap
            .asObservable()
            .map({
                return self.viewModel.selectedSortType.value
            })
            .asDriver(onErrorJustReturn: .distance)
            .drive(onNext: { (sort) in
                self.showSortOrderDiaglog(with: sort)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Local Methdos
    
    private func showSortOrderDiaglog(with sortType:SortType) {
        SortOrderDialog.show(selected: sortType) { (finished, sort) in
            if finished {
                self.viewModel.setSortType(sort!)
            }
        }
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
        setupSortOrderButtonBinding()
        fetchWithinElements()
    }
    
    // MARK: - Fetch Table View
    
    private func fetchWithinElements() {
        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { indexPath in
            //   self.viewModel.loadModels(brandIdx: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .map { source in
                return source.count == 0
            }
            .subscribe(onNext: { isEmpty in
                self.dataView.isHidden = isEmpty ? true : false
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
                let cell = self.tableView.dequeueReusableCell(withIdentifier:
                    "ParkingDistanceTableViewCell", for: IndexPath(item: row, section: 0)) as! ParkingDistanceTableViewCell
                cell.configure(item, tags: self.viewModel.getTags(item))
                
                return cell
            }
            .disposed(by: disposeBag)
 
   /*
        tableView.register(ParkingDistanceTableViewCell.self, forCellReuseIdentifier: "ParkingDistanceTableViewCell")
        tableView.register(ParkingPriceTableViewCell.self, forCellReuseIdentifier: "ParkingPriceTableViewCell")
        
        viewModel.elements
            .bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
    
                let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingDistanceTableViewCell") as! ParkingDistanceTableViewCell
        
                cell.configure(item, tags: self.viewModel.getTags(item))
        
                          
                //let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingDistanceTableViewCell", for: IndexPath.init(row: row, section: 0)) as! ParkingDistanceTableViewCell
                
               // let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingPriceTableViewCell", for: IndexPath.init(row: row, section: 0))
                return cell
            }
            .disposed(by: disposeBag)
 */
    }
    
    // MARK: - Public Methods
    
    public func getViewModel() -> ParkingTapViewModelType {
        return self.viewModel
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
