//
//  PaymentHistoryUsedTicketViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

fileprivate typealias HistoryUsedSectionModel = SectionModel<String, OrderElement>
fileprivate typealias HistoryUsedDataSource = RxTableViewSectionedReloadDataSource<HistoryUsedSectionModel>

class PaymentHistoryUsedTicketViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var historyUsedItems: BehaviorRelay<[OrderElement]> = BehaviorRelay(value: [])
    private var historyUsedCategoryItems: BehaviorRelay<[Date]> = BehaviorRelay(value: [])
      
    private var historyUsedSectionItems: BehaviorRelay<[(title:String, items:[OrderElement])]> = BehaviorRelay(value: [])
    
    fileprivate var dataSource:HistoryUsedDataSource?
    
    var selectAction: ((_ element:OrderElement) -> Void)?
    
    private let disposeBag = DisposeBag()

    // MARK: - Binding
    
    private func setupTableViewBinding() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        historyUsedItems.asObservable()
            .map { items in
                return items.map { return $0.dateCreated.toDate!.withoutTimeStamp }.uniqued()
            }
            .bind(to: historyUsedCategoryItems)
            .disposed(by: disposeBag)

        
        historyUsedCategoryItems
            .asObservable()
            .map { items in
                return items.map { [unowned self] date -> HistoryUsedSectionModel in
                    let elements:[OrderElement] = self.historyUsedItems.value.filter {
                        return date.compare(.isSameDay(as: $0.dateCreated.toDate!))
                    }
                    
                    let dateName = DisplayDateTimeHandler().displayDateYYmD(with: date)
                    return HistoryUsedSectionModel(model: dateName, items: elements)
                }
            }
            .bind(to: tableView.rx.items(dataSource: getHistoryUsedItemDataSource()))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(OrderElement.self)
            .subscribe(onNext: { item in
                if let action = self.selectAction {
                    action(item)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func getHistoryUsedItemDataSource() -> HistoryUsedDataSource {
        guard dataSource == nil else {
            return dataSource!
        }
        
        let configureCell: (TableViewSectionedDataSource<HistoryUsedSectionModel>, UITableView,IndexPath, OrderElement) -> UITableViewCell = { (dataSource, tableView, indexPath,  element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryUsedTicketTableViewCell", for: indexPath) as? PaymentHistoryUsedTicketTableViewCell else { return UITableViewCell() }
            
            cell.configure(title: element.product?.name ?? "", price: element.totalAmount, place: element.parkingLot?.name ?? "", carNumber: element.car?.number ?? "", productType: element.type!)
            
            return cell
        }
        
        dataSource = HistoryUsedDataSource.init(configureCell: configureCell)
            
        return dataSource!
    }
    
    // MARK: - Public Methos
    
    public func setOrderElement(_ elements:[OrderElement]) {
        historyUsedItems.accept(elements)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupTableViewBinding()
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


extension PaymentHistoryUsedTicketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = PaymentHistoryTableViewHeader.loadFromXib() as! PaymentHistoryTableViewHeader
        
        if let source = dataSource {
            let titleString = source.sectionModels[section].model
            header.setTitle(titleString)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
