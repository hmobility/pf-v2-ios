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
    
    var detailButtonAction: ((_ element:WithinElement) -> Void)?
    var reserveButtonAction: ((_ element:WithinElement) -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let columnLayout = ColumnFlowLayout(
           cellsPerRow: 1,
           minimumInteritemSpacing: 0,
           minimumLineSpacing: 20,
           sectionInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
       )
    
    var disposeBag = DisposeBag()

    private lazy var viewModel: ParkingCardViewModelType = ParkingCardViewModel()

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
    
    public func getViewModel() -> ParkingCardViewModelType {
        return self.viewModel
    }
    
    // MARK: - Local Methods
    
    private func setDetailParkinglot(_ element:WithinElement) {
        detailButtonAction?(element)
    }
    
    private func setReserveParkinglot(_ element:WithinElement) {
        reserveButtonAction?(element)
    }
    
    // MARK: - Fetch Collection View
    
    private func fetchWithinElements() {
        collectionView.rx.itemSelected.asDriver()
            .drive(onNext: { indexPath in
            //   self.viewModel.loadModels(brandIdx: indexPath.row)
            })
            .disposed(by: disposeBag)
     
        viewModel.elements
            .bind(to: collectionView.rx.items(cellIdentifier: "ParkinglotCardCollectionViewCell", cellType: ParkinglotCardCollectionViewCell.self)) { row, item, cell in
                let tags = self.viewModel.getTags(item)
                cell.setTitle(item.name, distance: item.distance)
                cell.setPrice(item.price)
                cell.setTagList(tags)
                cell.setReserveEnabled(item.available)
                
                cell.detailTap
                    .asObservable()
                    .subscribe(onNext: { indexPath in
                        if let index = indexPath?.row {
                            let element = self.viewModel.elements.value[index]
                            self.setDetailParkinglot(element)
                        }
                        debugPrint("[DETAIL INDEX]", indexPath)
                    })
                    .disposed(by: self.disposeBag)
                
                cell.rserveTap
                    .asObservable()
                    .subscribe(onNext: { indexPath in
                        if let index = indexPath?.row {
                            let element = self.viewModel.elements.value[index]
                            self.setReserveParkinglot(element)
                        }
                        debugPrint("[RSERVE INDEX]", indexPath)
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
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
