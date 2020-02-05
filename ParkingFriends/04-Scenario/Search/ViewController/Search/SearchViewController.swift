//
//  ParkingSearchViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class SearchViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var historyView: UITableView!
    @IBOutlet weak var tapSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    private var embedNavigationController: UINavigationController?
    
    private var viewModel: SearchViewModelType = SearchViewModel()
    
    private lazy var searchBar = UISearchBar()
    
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.phSearchParkinglotText
            .asDriver()
            .drive(searchBar.rx.placeholder)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        backButton.rx.tap
             .subscribe(onNext: { _ in
                 self.dismissRoot()
             })
             .disposed(by: disposeBag)
    }
    
    private func setupSegmentedControl() {
        tapSegmentedControl.addTarget(self, action:#selector(segmentValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            navigateToGuide()
        } else {
           // navigateToFavorite()
            navigateToEmptyFavorite()
        }
    }
    
    // MARK: - Setup View
    
    private func setupNavigation() {
        if let topItem = navigationBar.topItem {
            searchBar.searchTextField.borderStyle = .none
            searchBar.searchTextField.textAlignment = .left
            searchBar.setImage(UIImage(), for: .search, state: .normal)
            topItem.titleView = searchBar
        }
    }
    
    private func setupTapMenu() {
        viewModel.getTapItems()
            .asObservable()
            .subscribe(onNext: { [unowned self] items in
                self.updateSegmentedControl(items)
            })
           .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
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
        
        setupSegmentedControl()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Navigation
    
    private func navigateToGuide() {
           let target = Storyboard.search.instantiateViewController(withIdentifier: "SearchGuideViewController") as! SearchGuideViewController
           
           if let navigation = embedNavigationController {
               navigation.viewControllers = [target]
           }
       }
    
    
    private func navigateToEmptyFavorite() {
        let target = Storyboard.search.instantiateViewController(withIdentifier: "SearchFavoriteEmptyViewController") as! SearchFavoriteEmptyViewController
        
        if let navigation = embedNavigationController {
            navigation.viewControllers = [target]
        }
    }
    
    private func navigateToFavorite() {
        let target = Storyboard.search.instantiateViewController(withIdentifier: "SearchFavoriteViewController") as! SearchFavoriteViewController
      
        if let navigation = embedNavigationController {
            navigation.viewControllers = [target]
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
