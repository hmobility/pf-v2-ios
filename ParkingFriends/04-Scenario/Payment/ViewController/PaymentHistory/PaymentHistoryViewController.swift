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

private enum PaymentHistoryTapIndex:Int {
    case reservation_history, used_history
}

class PaymentHistoryViewController: UIViewController {
    @IBOutlet weak var tapSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private var embedNavigationController: UINavigationController?
    private var reservationViewController: PaymentHistoryReserveViewController?
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
                if tapIndex == .reservation_history {
                    self.setupReservationHistoryView()
                } else {
                    self.setupUsedTicketHistoryView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupReservationHistoryView() {
        navigateToEmptyReservation()
        /*
         Observable.combineLatest(tapSegmentedControl.rx.selected,
                                         viewModel.searchResults)
             .filter { PaymentHistoryTapIndex(rawValue: $0.0) == .reservation_history }
             .map { return $0.1 }
             .asObservable()
             .subscribe(onNext:{ [unowned self] items in
                 self.setHistoryViewVisiblity(hiding: true)
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
 */
    }
     
    private func setupUsedTicketHistoryView() {
        navigateToEmptyUsedHistory()
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
    
    private func navigateToEmptyReservation() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryEmptyReservationViewController") as! PaymentHistoryEmptyReservationViewController
        setEmbedView(target)
    }
    
    private func navigateToEmptyUsedHistory() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryEmptyHistoryViewController") as! PaymentHistoryEmptyHistoryViewController
        setEmbedView(target)
    }
    
    private func navigateToReservation() {
        guard let navigationController = embedNavigationController, reservationViewController != navigationController.viewControllers[0] else {
            return
        }
        
        if reservationViewController == nil {
            reservationViewController = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryReserveViewController") as? PaymentHistoryReserveViewController
            //reservationViewController?.setViewModel(viewModel as! SearchViewModel)
        }
        
        if let target = reservationViewController {
            setEmbedView(target)
          //  target.setFavoriteItems(items)
           /*
            target.selectAction = { [unowned self] item in
                debugPrint("[FAVORITE] SELECT, ", item.name)
                self.navigateToDetail(with: item)
            }
 */
        }
    }
    
    private func navigateToUsedTicket() {
        guard let navigationController = embedNavigationController, usedTicketViewController != navigationController.viewControllers[0] else {
            return
        }
        
        if usedTicketViewController == nil {
            usedTicketViewController = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentHistoryUsedTicketViewController") as? PaymentHistoryUsedTicketViewController
            //reservationViewController?.setViewModel(viewModel as! SearchViewModel)
        }
        
        if let target = usedTicketViewController {
            setEmbedView(target)
            //  target.setFavoriteItems(items)
            /*
             target.selectAction = { [unowned self] item in
             debugPrint("[FAVORITE] SELECT, ", item.name)
             self.navigateToDetail(with: item)
             }
             */
        }
    }
    
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
