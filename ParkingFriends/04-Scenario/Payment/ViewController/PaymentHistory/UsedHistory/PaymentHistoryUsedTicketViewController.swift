//
//  PaymentHistoryUsedTicketViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class PaymentHistoryUsedTicketViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var historyItems: BehaviorRelay<[OrderElement]> = BehaviorRelay(value: [])
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Methos
    
    public func setOrderElement(_ elements:[OrderElement]) {
        historyItems.accept(elements)
    }
    
    // MARK: - Binding
    
    private func setupOrderHistoryBinding() {
        historyItems
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "PaymentHistoryUsedTicketTableViewCell", cellType: PaymentHistoryUsedTicketTableViewCell.self)) { row , item, cell in
                cell.configure(title: item.product!.name, price: item.totalAmount, place: item.parkinglot!.name, carNumber: item.car!.number, productType: item.type!)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(OrderElement.self)
            .subscribe(onNext: { item in
     
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupOrderHistoryBinding()
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
