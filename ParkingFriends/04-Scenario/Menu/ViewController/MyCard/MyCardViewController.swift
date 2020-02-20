//
//  MyCardViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension MyCardViewController: AnalyticsType {
    var screenName: String {
        return "[SCREEN] My Card List"
    }
}

class MyCardViewController: UIViewController {
    @IBOutlet weak var noCardView: UIView!
    @IBOutlet weak var addCardButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
           didSet {
               tableView.tableFooterView = UIView(frame: .zero)
           }
       }
    
    private var embedNavigationController: UINavigationController?
    private var myCardListViewController: MyCardListViewController?
    private var myCardEmptyViewController: MyCardEmptyViewController?
    
    private var viewModel: MyCardViewModelType = MyCardViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitle
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.dismissModal()
            })
         .disposed(by: disposeBag)
    }
    
    private func setupCardListBinding() {
        viewModel.getCardItems()
            .asObservable()
            .subscribe(onNext: { [unowned self] items in
                if items.count > 0 {
                    self.navigateToCardList(with: items)
                } else {
                    self.navigateToEmptyCard()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func loadCreditCadInfo() {
        viewModel.loadCreditCard()
    }
    
    // MARK: - Local Methods
    
    private func setEmbedView(_ target:UIViewController) {
        if let navigationController = embedNavigationController {
            self.addChild(target)
            navigationController.viewControllers = [target]
            target.didMove(toParent: self)
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
        loadCreditCadInfo()
        setupNavigationBinding()
        setupButtonBinding()
        setupCardListBinding()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    

    // MARK: - Navigation
    
    private func navigateToEmptyCard() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "MyCardEmptyViewController") as! MyCardEmptyViewController
        setEmbedView(target)
    }
    
    private func navigateToCardList(with elements:[CardElement]) {
        if myCardListViewController == nil {
            myCardListViewController = Storyboard.menu.instantiateViewController(withIdentifier: "MyCardListViewController") as? MyCardListViewController
        }
        
        if let target = myCardListViewController {
            setEmbedView(target)
            target.setCardItems(elements)
        }
    }
    
    // MARK: Prepare
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CreditCardListNavigation":
            guard let navigationController = segue.destination as? UINavigationController else {
                print("NavigationViewController is not generated."); return }
            self.embedNavigationController = navigationController
        default:
            break
        }
    }

}
