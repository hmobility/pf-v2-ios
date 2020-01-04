//
//  LevelGuideViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension LevelGuideViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Level Guide"
    }
}

class LevelGuideViewController: UIViewController {
   
    @IBOutlet weak var navigationBar:UINavigationBar!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
  
    @IBOutlet weak var progressView:UIProgressView!
    @IBOutlet weak var startLevelImageView:UIImageView!
    @IBOutlet weak var endLevelImageView:UIImageView!
    @IBOutlet weak var gaugeGuideLabel:UILabel!
    
    @IBOutlet weak var backButton:UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    private lazy var viewModel: LevelGuideViewModelType = LevelGuideViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupButtonBinding() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.dismissModal()
            })
         .disposed(by: disposeBag)
    }
    
    
    // MARK: - Fetch
    
    private func fetchLevelItem() {
        viewModel.levelItemList
            .bind(to: tableView.rx.items(cellIdentifier: "LevelGuideTableViewCell", cellType: LevelGuideTableViewCell.self)) { row, item, cell in
                cell.configure(level:item.level, title:item.title, desc:item.desc, benefit:item.benefit)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
       
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupButtonBinding()
        
        fetchLevelItem()
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
