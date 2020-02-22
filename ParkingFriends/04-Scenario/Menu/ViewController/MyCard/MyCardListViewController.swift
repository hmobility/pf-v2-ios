//
//  MyCardListViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/18.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MyCardListViewController: UIViewController {
    @IBOutlet var headerTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
           didSet {
               tableView.tableFooterView = UIView(frame: .zero)
           }
       }
    
    private var cardItems:BehaviorRelay<[CardElement]> = BehaviorRelay(value:[])

    var selectAsDefaultAction: ((_ id:Int) -> Void)?
    var removeAction: ((_ id:Int) -> Void)?
    
    private let disposeBag = DisposeBag()

    // MARK: - Binding
    
    private func setupCardItemBinding() {
        cardItems.bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
                let indexPath = IndexPath(item: row, section: 0)
                if indexPath.row == 1 {
                    item.defaultFlag = false
                }
            
                if item.defaultFlag {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier:
                                       "MyCardDefaultTableViewCell", for: indexPath) as! MyCardDefaultTableViewCell
                    cell.configure(title: item.cardName, cardNumber: item.cardNo)
                    cell.removeAction = { [unowned self] flag in
                        self.removeCard(with: item.id)
                    }
                    
                    return cell
                } else {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier:
                                            "MyCardNormalTableViewCell", for: indexPath) as! MyCardNormalTableViewCell
                    cell.configure(title: item.cardName, cardNumber: item.cardNo)
                    cell.removeAction = { [unowned self] flag in
                        self.removeCard(with: item.id)
                    }
                    cell.selectAsDefaultAction = { [unowned self] flag in
                        self.setDefaultCard(with: item.id)
                    }
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func removeCard(with cardId:Int) {
        if let action = removeAction {
            action(cardId)
        }
    }
    
    private func setDefaultCard(with cardId:Int) {
        if let action = selectAsDefaultAction {
            action(cardId)
        }
    }
    
    // MARK: - Public Methods
    
    public func setCardItems(_ elements:[CardElement]) {
        var array = Array<CardElement>()
        array.append(elements[0])
        array.append(elements[0])
        cardItems.accept(array)
    }
       
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupCardItemBinding()
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
