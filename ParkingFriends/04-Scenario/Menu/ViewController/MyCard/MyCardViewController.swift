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
        return "[SCREEN] My Card"
    }
}

class MyCardViewController: UIViewController {
    
    @IBOutlet weak var noCardView: UIView!
    
    @IBOutlet var myCardHeaderView: MyCardHeaderView!
    @IBOutlet weak var tableView: UITableView! {
           didSet {
               tableView.tableFooterView = UIView(frame: .zero)
           }
       }
    
    @IBOutlet weak var backButton: UIButton!
    
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
    
    // MARK: - Fetch Table View
    
    private func fetchCards() {
        viewModel.elements
            .map { element in
                return element.count == 0
            }
            .subscribe(onNext: { isEmpty in
                self.tableView.isHidden = isEmpty ? true : false
            })
            .disposed(by: disposeBag)
        
       /*
        viewModel.elements
            .map { $0.count > 0 }
            .bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier:
                    "BasicCardTableViewCell", for: IndexPath(item: row, section: 0)) as! BasicCardTableViewCell
                cell.configure(item, tags: self.viewModel.getTags(item))
                
                return cell
        }
        .disposed(by: disposeBag)
 */
    }
    
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupNavigationBinding()
        setupButtonBinding()
        fetchCards()
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
