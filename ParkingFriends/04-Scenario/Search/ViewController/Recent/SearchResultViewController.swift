//
//  SearchRessultViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension SearchResultViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Search Result"
    }
}

class SearchResultViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var selectAction: ((_ coord:CoordType) -> Void)?
    
    private var viewModel: SearchViewModelType?
       
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupTableViewBinding() {
        if let viewModel = self.viewModel {
            viewModel.searchResults.asObservable()
                .filter { $0 != nil }
                .map { $0!}
                .bind(to: tableView.rx.items(cellIdentifier: "SearchResultItemTableViewCell", cellType: SearchResultItemTableViewCell.self)) { row , item, cell in
                    cell.setTitle(with: item.name, description: item.road_address)
                }
                .disposed(by: disposeBag)
            
            //*
            tableView.rx.modelSelected(Place.self)
                .subscribe(onNext: { place in
                    debugPrint("[MODEL][COORD]", place)
                    if let action = self.selectAction {
                        let coord = CoordType(latitude:place.y.doubleValue, longitude:place.x.doubleValue)
                        action(coord)
                    }
                })
                .disposed(by: disposeBag)
 //*/
            
            /*
            tableView.rx.itemSelected
                .map { indexPath in
                    return viewModel.searchResults.value![indexPath.row]
                }
                .subscribe(onNext:{ [unowned self] item in
                    if let action = self.selectAction {
                        let coord = CoordType(latitude:item.y.doubleValue, longitude:item.x.doubleValue)
                        debugPrint("[COORD]", coord)
                        action(coord)
                    }
                })
                .disposed(by: disposeBag)
 */
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
        setupTableViewBinding()
    }
    
    // MARK: - Public Methods
    
    public func setViewModel(_ viewModel:SearchViewModel) {
        self.viewModel = viewModel
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
