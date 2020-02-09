//
//  SearchFavoriteViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension SearchFavoriteViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Search Favorite"
    }
}

class SearchFavoriteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    private var viewModel: SearchViewModelType?
    private var favoriteItems:[FavoriteElement]?
    
    var selectAction: ((_ id:Int) -> Void)?
    
    var disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setViewModel(_ viewModel:SearchViewModel) {
        self.viewModel = viewModel
    }
    
    public func setFavoriteItems(_ items:[FavoriteElement]) {
        self.favoriteItems = items
    }
    
    // MARK: - Binding
    
    private func setupTableViewBinding() {
        _ = Observable.from(optional: favoriteItems)
            .ifEmpty(default: [])
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "SearchFavoriteItemTableViewCell", cellType: SearchFavoriteItemTableViewCell.self)) { row , item, cell in
                cell.setTitle(with: item.name)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(FavoriteElement.self)
            .subscribe(onNext: { item in
                debugPrint("[MODEL][COORD]", item)
                if let action = self.selectAction{
                    action(item.id)
                }
            })
            .disposed(by: disposeBag)
               
      /*
        tableView.rx.itemSelected
            .subscribe(onNext:{ [unowned self] indexPath in
                if let items = self.favoriteItems {
                    if items.count < indexPath.row {
                        if let action = self.selectAction, let parkinglotId = items[indexPath.row].parkinglot?.id {
                            action(parkinglotId)
                        }
                            
                    }
                }
                debugPrint("[SELECT]", indexPath)
            })
            .disposed(by: disposeBag)
        */
        tableView.tableFooterView = footerView
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
    
    // MARK: - Life Cycle
    
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
