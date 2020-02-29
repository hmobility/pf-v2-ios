//
//  PaymentHistoryViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import BetterSegmentedControl

extension PaymentHistoryViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Payment History Main"
    }
}

enum PaymentHistoryTapIndex:Int {
    case reserved_history, used_history
}

class PaymentHistoryViewController: UIViewController {
    @IBOutlet weak var tapSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private var embedNavigationController: UINavigationController?
    private var paidTicketViewController: PaymentHistoryPaidTicketViewController?
    private var usedTicketViewController: PaymentHistoryUsedTicketViewController?
    
    private var viewModel:PaymentHistoryViewModelType = PaymentHistoryViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupNavigationBinding() {
        viewModel.viewTitleText
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.dismissRoot()
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
    
    private func setupTapSwitchBinding() {
        tapSegmentedControl.rx.selected
            .asDriver()
            .distinctUntilChanged()
            .map {
                return PaymentHistoryTapIndex(rawValue: $0)
            }
            .drive(onNext: { [unowned self] tapIndex in
                if tapIndex == .reserved_history {
                    self.setupPaidTicketHistoryView()
                } else {
                    self.setupUsedTicketHistoryView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPaidTicketHistoryView() {
        viewModel.getPaidItems()
            .asObservable()
            .subscribe(onNext: { [unowned self] items in
                if items.count > 0 {
                    self.navigateToPaid(with: items)
                } else {
                    self.navigateToEmptyPaid()
                }
            })
            .disposed(by: disposeBag)
    }
     
    private func setupUsedTicketHistoryView() {
        viewModel.getUsedItems()
            .asObservable()
            .subscribe(onNext: { [unowned self] items in
                if items.count > 0 {
                    self.navigateToUsedTicket(with: items)
                } else {
                    self.navigateToEmptyUsedHistory()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupNavigationBinding()
        setupTapMenu()
        setupTapSwitchBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Local Methods
    
    private func updateSegmentedControl(_ items:[String]) {
        tapSegmentedControl.options = [.backgroundColor(UIColor.white),
                                       .indicatorViewBackgroundColor(UIColor.white),
                                       .indicatorViewInset(0),
                                       .cornerRadius(0.0),
                                       .animationSpringDamping(1.0),
                                       .panningDisabled(true)]
        
        tapSegmentedControl.segments = LabelSegment.segments(withTitles: items,
                                                             normalFont: Font.gothicNeoMedium18,
                                                             normalTextColor: Color.coolGrey,
                                                             selectedFont: Font.gothicNeoMedium18,
                                                             selectedTextColor: Color.darkGrey3,
                                                             selectedUnderlineBorder: 2.0,
                                                             selectedUnderlineColor: Color.algaeGreen)
    }
    
    private func setEmbedView(_ target:UIViewController) {
        if let navigationController = embedNavigationController {
            self.addChild(target)
            navigationController.viewControllers = [target]
            target.didMove(toParent: self)
        }
    }
       
    // MARK: - Navigation
    
    private func navigateToParkingStatus(with element:OrderElement) {
        let target = Storyboard.parking.instantiateViewController(withIdentifier: "ParkingStatusNavigationController") as! ParkingStatusNavigationController
        target.setOrderElement(with: element)
        self.modal(target)
    }
    
    private func navigateToEmptyPaid() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryEmptyPaidTicketViewController") as! PaymentHistoryEmptyPaidTicketViewController
        setEmbedView(target)
    }
    
    private func navigateToEmptyUsedHistory() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryEmptyUsedTicketViewController") as! PaymentHistoryEmptyUsedTicketViewController
        setEmbedView(target)
    }
    
    private func navigateToPaid(with elements:[OrderElement]) {
        if paidTicketViewController == nil {
            paidTicketViewController = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryPaidTicketViewController") as? PaymentHistoryPaidTicketViewController
        }
        
        if let target = paidTicketViewController {
            setEmbedView(target)
            target.setOrderElement(elements)
            
            target.selectAction = { [unowned self] element in
                self.navigateToParkingStatus(with: element)
            }
        }
    }
    
    private func navigateToUsedTicket(with elements:[OrderElement]) {
        if usedTicketViewController == nil {
            usedTicketViewController = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryUsedTicketViewController") as? PaymentHistoryUsedTicketViewController
        }
        
        if let target = usedTicketViewController {
            setEmbedView(target)
            target.setOrderElement(elements)
            
            target.selectAction = { [unowned self] element in
                self.navigateToReceipt(with: element)
            }
        }
    }
    
    private func navigateToReceipt(with element:OrderElement) {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentReceiptViewController") as! PaymentReceiptViewController
        //target.setOrderElement(with: element)
        target.setUrl(with: element.receiptUrl)             // Changed into assigng url directly, instead of assigning OrderElement
        self.modal(target)
    }
    
    // MARK: Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PaymentHistoryNavigation":
            guard let navigationController = segue.destination as? UINavigationController else {
                print("NavigationViewController is not generated."); return }
            self.embedNavigationController = navigationController
        default:
            break
        }
    }
}
