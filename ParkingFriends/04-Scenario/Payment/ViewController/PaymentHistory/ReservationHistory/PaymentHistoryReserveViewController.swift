//
//  PaymentHistoryReservationViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

fileprivate typealias HistorySectionModel = SectionModel<String, OrderElement>
fileprivate typealias HistoryDataSource = RxTableViewSectionedReloadDataSource<HistorySectionModel>

class PaymentHistoryReserveViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var historyItems: BehaviorRelay<[OrderElement]> = BehaviorRelay(value: [])
    private var historyCategoryItems: BehaviorRelay<[Date]> = BehaviorRelay(value: [])
    
    private var historySectionItems: BehaviorRelay<[(title:String, items:[OrderElement])]> = BehaviorRelay(value: [])

    private let disposeBag = DisposeBag()
    
    fileprivate var dataSource:HistoryDataSource?
    
    // MARK: - Binding
    
    private func setupTableViewBinding() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        historyItems.asObservable()
            .map { items in
                return items.map { return $0.dateCreated.toDate!.withoutTimeStamp }.uniqued()
            }
            .bind(to: historyCategoryItems)
            .disposed(by: disposeBag)

        
        historyCategoryItems
            .asObservable()
            .map { items in
                return items.map { [unowned self] date -> HistorySectionModel in
                    let elements:[OrderElement] = self.historyItems.value.filter {
                        return date.compare(.isSameDay(as: $0.dateCreated.toDate!))
                    }
                    let dateName = DisplayDateTimeHandler().displayDateYYmD(with: date)
                    return HistorySectionModel(model: dateName, items: elements)
                }
            }
            .bind(to: tableView.rx.items(dataSource: getHistoryItemDataSource()))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(OrderElement.self)
            .subscribe(onNext: { item in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func getHistoryItemDataSource() -> HistoryDataSource {
        guard dataSource == nil else {
            return dataSource!
        }
        
        let configureCell: (TableViewSectionedDataSource<HistorySectionModel>, UITableView,IndexPath, OrderElement) -> UITableViewCell = { (dataSource, tableView, indexPath,  element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryReserveTableViewCell", for: indexPath) as? PaymentHistoryReserveTableViewCell else { return UITableViewCell() }
            
            cell.configure(title: element.product?.name ?? "", price: element.totalAmount, place: element.parkingLot?.name ?? "", carNumber: element.car?.number ?? "", productType: element.type!)
            return cell
        }
        
        
        dataSource = HistoryDataSource.init(configureCell: configureCell)
            
        return dataSource!
    }
    
       
    // MARK: - Public Methods
    
    public func setOrderElement(_ elements:[OrderElement]) {
        historyItems.accept(elements)
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
    

    // MARK: - Navigation
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PaymentHistoryReserveViewController: UITableViewDelegate {
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
