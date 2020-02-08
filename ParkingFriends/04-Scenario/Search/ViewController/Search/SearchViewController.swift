//
//  ParkingSearchViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import BetterSegmentedControl

private enum TapIndex:Int {
    case recent_search, favorite_search
}

class SearchViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tapSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var historyStackView: UIStackView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var historyFooterView: SearchHistoryFooterView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    private var embedNavigationController: UINavigationController?
    private var searchResultViewController: SearchResultViewController?
    private var favoriteViewController: SearchFavoriteViewController?
    
    private var viewModel: SearchViewModelType = SearchViewModel()
    private var location:CoordType?
    
    private var searchBar = UISearchBar()
    
    var disposeBag = DisposeBag()
    
    // MARK: - Setup Navigation
    
    private func setupNavigation() {
        if let topItem = navigationBar.topItem {
            searchBar.searchTextField.borderStyle = .none
            searchBar.searchTextField.textAlignment = .left
            searchBar.setImage(UIImage(), for: .search, state: .normal)
            topItem.titleView = searchBar
        }
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.phSearchParkinglotText
            .asDriver()
            .drive(searchBar.rx.placeholder)
            .disposed(by: disposeBag)
        
        containerView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        backButton.rx.tap
             .subscribe(onNext: { _ in
                 self.dismissModal()
             })
             .disposed(by: disposeBag)
    }
    
    private func setupTapSwitchBinding() {
        tapSegmentedControl.rx.selected
            .asDriver()
            .distinctUntilChanged()
            .do {
                self.view.endEditing(true)
            }
            .map {
                return TapIndex(rawValue: $0)
            }
            .drive(onNext: { [unowned self] tapIndex in
                if tapIndex == .recent_search {
                    self.setupSearchResultView()
                } else {
                    self.setupFavoriteItemsView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTapMenu() {
        viewModel.getTapItems()
            .asObservable()
            .subscribe(onNext: { [unowned self] items in
                self.updateSegmentedControl(items)
            })
           .disposed(by: disposeBag)
    }
    
    // MARK: - History Binding
    
    private func setupHistoryBinding() {
        viewModel.historyItems
            .asObservable()
            .bind(to: historyTableView.rx.items(cellIdentifier: "SearchHistoryItemTableViewCell", cellType: SearchHistoryItemTableViewCell.self)) { [unowned self] row, item, cell in
                cell.setTitle(with: item)
                cell.removeAction = { index in
                    self.viewModel.removeHistory(with: index)
                }
            }
            .disposed(by: disposeBag)
        
        historyTableView.rx.itemSelected
            .map { [unowned self] indexPath in
                return self.viewModel.historyItems.value[indexPath.row]
            }
            .subscribe(onNext:{ [unowned self] text in
                self.searchBar.text = text
                debugPrint("[HISTORY]", text)
            })
            .disposed(by: disposeBag)
        
        historyTableView.tableFooterView = historyFooterView
        
        historyFooterView.removeAllAction = { [unowned self] finished in
            self.viewModel.resetHistory()
        }
        
        setHistoryViewVisiblity(hiding: true)
    }
    
    // MARK: - Search Binding
    
    private func setupSearchBarBinding() {
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { _ in
                debugPrint("[CANCEL] Query")
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe({ [unowned self] text in
                self.setHistoryViewVisiblity(hiding: false)
            })
            .disposed(by: disposeBag)

    //    let search = Observable.combineLatest(searchBar.rx.text.orEmpty,
    //                             searchBar.rx.searchButtonClicked)
            
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                debugPrint("[RETURN] text: \(text)")
                
                if let coordinate = self.location {
                    self.viewModel.requestSearch(with: text, coordinate: coordinate)
                }
            })
            .disposed(by: disposeBag)
        
       // let editing = Observable.combineLatest(searchBar.rx.text,
       //                          searchBar.rx.textDidEndEditing.startWith(()))
        
        searchBar.rx.textDidBeginEditing.startWith(())
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                debugPrint("[STRT] text: \(text)")
                if text.isEmpty {
                    self.setHistoryViewVisiblity(hiding: true)
                } else {
                    self.setHistoryViewVisiblity(hiding: false)
                }
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing.startWith(())
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                debugPrint("[END] text: \(text)")
                if text.isEmpty {
                    self.viewModel.resetSearch()
                    self.setHistoryViewVisiblity(hiding: true)
                } else {
                    self.setHistoryViewVisiblity(hiding: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchResultView() {
        Observable.combineLatest(tapSegmentedControl.rx.selected,
                                        viewModel.searchResults)
            .filter { TapIndex(rawValue: $0.0) == .recent_search }
            .map { return $0.1 }
            .asObservable()
            .subscribe(onNext:{ [unowned self] items in
                if let results = items {
                    if results.count > 0 {
                        self.navigateToSearchResults(with: results)
                    } else {
                        self.navigateToNoResult()
                    }
                } else {
                    self.navigateToGuide()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Favorite Binding
    
    private func setupFavoriteItemsView() {
        viewModel.getFavoriteItems()
            .asDriver(onErrorJustReturn: [])
            .drive(onNext:{ [unowned self] items in
                if items.count > 0 {
                    self.navigateToFavorite(with: items)
                } else {
                    self.navigateToEmptyFavorite()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func setLocation(_ coordinate:CoordType) {
        location = coordinate
    }
    
    // MARK: - Local Methods
    
    private func setEmbedView(_ target:UIViewController) {
        if let navigation = embedNavigationController {
            navigation.viewControllers = [target]
        }
    }
    
    private func setHistoryViewVisiblity(hiding flag:Bool) {
        viewModel.historyItems
            .asDriver()
            .map {
                return $0.count == 0
            }
            .map {
                return flag != $0 ? flag : $0
            }
            .distinctUntilChanged()
            .drive(onNext:{ hide in
                if self.historyStackView.isHidden != hide {
                    self.historyStackView.isHidden = hide
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateSegmentedControl(_ items:[String]) {
        tapSegmentedControl.options = [.backgroundColor(UIColor.white),
                                    .indicatorViewBackgroundColor(UIColor.white),
                                    .cornerRadius(0.0),
                                    .animationSpringDamping(1.0),
                                    .panningDisabled(true)]
        
        tapSegmentedControl.segments = LabelSegment.segments(withTitles: items,
                                    normalFont: Font.gothicNeoMedium18,
                                    normalTextColor: Color.coolGrey,
                                    selectedFont: Font.gothicNeoMedium18,
                                    selectedTextColor: Color.darkGrey3)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupNavigation()
 
        setupTapMenu()
        
        setupBinding()
        setupButtonBinding()
        setupSearchBarBinding()
        setupTapSwitchBinding()
        setupHistoryBinding()
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Navigation
    
    private func navigateToGuide() {
        let target = Storyboard.search.instantiateViewController(withIdentifier: "SearchGuideViewController") as! SearchGuideViewController
        setEmbedView(target)
    }
    
    private func navigateToNoResult() {
         let target = Storyboard.search.instantiateViewController(withIdentifier: "SearchNoResultViewController") as! SearchNoResultViewController
         setEmbedView(target)
     }
     
    private func navigateToSearchResults(with items:[Place]) {
        guard let navigationController = embedNavigationController, searchResultViewController != navigationController.viewControllers[0] else {
            return
        }
        
        if searchResultViewController == nil {
            searchResultViewController = Storyboard.search.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController
            searchResultViewController?.setViewModel(viewModel as! SearchViewModel)
        }
        
        if let target = searchResultViewController {
            setEmbedView(target)
            
            target.selectAction = { coordinate in
                // TO DO
            }
        }
    }
    
    private func navigateToEmptyFavorite() {
        let target = Storyboard.search.instantiateViewController(withIdentifier: "SearchFavoriteEmptyViewController") as! SearchFavoriteEmptyViewController
        setEmbedView(target)
    }
    
    private func navigateToFavorite(with items:[FavoriteElement]) {
        guard let navigationController = embedNavigationController, favoriteViewController != navigationController.viewControllers[0] else {
            return
        }
        
        if favoriteViewController == nil {
            favoriteViewController = Storyboard.search.instantiateViewController(withIdentifier: "SearchFavoriteViewController") as? SearchFavoriteViewController
            favoriteViewController?.setViewModel(viewModel as! SearchViewModel)
        }
              
        if let target = favoriteViewController {
            setEmbedView(target)
            target.setFavoriteItems(items)
            
            target.selectAction = { parkinglotId in
                // TO DO
            }
        }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SearchNavigation":
            guard let navigationController = segue.destination as? UINavigationController else {
                print("NavigationViewController is not generated."); return }
            self.embedNavigationController = navigationController
        default:
            break
        }
    }
}
