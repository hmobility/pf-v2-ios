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
        return "[SCREEN] My Card Main"
    }
}

class MyCardViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
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
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismissModal()
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {  [unowned self] _ in
                self.navigateToAddingCard()
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
            target.removeAction = { [unowned self] cardId in
                self.removeCard(with: cardId)
            }
            target.selectAsDefaultAction = { [unowned self] cardId in
                self.setDefaultCard(with: cardId)
            }
        }
    }
    
    private func navigateToAddingCard() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "MyCardAddingViewController") as! MyCardAddingViewController
     
        self.modal(target)
    }
    
    
    // MARK: Card Handling Processs
    
    private func removeCard(with cardId:Int) {
        let text = viewModel.getAlertRemoveMessage()
        self.alert(title: text.message, actions: [AlertAction(title: text.done, type: 0, style: .default), AlertAction(title: text.cancel, type: 1, style: .cancel)])
            .asObservable()
            .subscribe(onNext: { [unowned self] index in
                if index == 0 {
                    self.viewModel.deleteCreditCard(with: cardId)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setDefaultCard(with cardId:Int) {
        let text = viewModel.getAlertDefaultMessage()
        self.alert(title: text.message, actions: [AlertAction(title: text.done, type: 0, style: .default), AlertAction(title: text.cancel, type: 1, style: .cancel)])
            .asObservable()
            .subscribe(onNext: { [unowned self] index in
                if index == 0 {
                    self.viewModel.setDefaultCreditCard(with: cardId)
                }
            })
            .disposed(by: disposeBag)
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
