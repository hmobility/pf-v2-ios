//
//  ParkinglotCardViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension ParkinglotCardViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Parkinglot Card"
    }
}


class ParkinglotCardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let columnLayout = ColumnFlowLayout(
           cellsPerRow: 1,
           minimumInteritemSpacing: 0,
           minimumLineSpacing: 20,
           sectionInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
       )
    
    var disposeBag = DisposeBag()

    private lazy var viewModel: ParkinglotCardViewModelType = ParkinglotCardViewModel()

    // MARK: - Initialize
     
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBinding()
        fetchWithinElements()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
       // collectionView?.sc
    }
    
    // MARK: - Public Methods
    
    public func getCardViewModel() -> ParkinglotCardViewModelType {
        return self.viewModel
    }
    
    // MARK: - Fetch Collection View
    
    private func fetchWithinElements() {
        collectionView.rx.itemSelected.asDriver()
            .drive(onNext: { indexPath in
            //   self.viewModel.loadModels(brandIdx: indexPath.row)
            })
            .disposed(by: disposeBag)
     
        viewModel.elements
            .bind(to: collectionView.rx.items(cellIdentifier: "ParkinglotCardCollectionViewCell", cellType: ParkinglotCardCollectionViewCell.self)) { row , item, cell in
           //     cell.setModel(item.name)
                let tags = self.viewModel.getTags(item)
                cell.setTitle(item.name, distance: item.distance)
                cell.setPrice(item.price)
            }
            .disposed(by: disposeBag)
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
