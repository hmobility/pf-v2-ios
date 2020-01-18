//
//  ParkinglotDetailSymbolView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/18.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkinglotDetailSymbolViewType {
    func setSymbolList(_ symbols:[SymbolType])
}

class ParkinglotDetailSymbolView: UIView {
   @IBOutlet weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var symbolList:BehaviorRelay<[SymbolType]> = BehaviorRelay(value: [])
    
    // MARK: - Public Methods
    
    func setSymbolList(_ symbols:[SymbolType]) {
        symbolList.accept(symbols)
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        symbolList.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "ParkinglotfDetailSymbolCollectionViewCell", cellType: ParkinglotfDetailSymbolCollectionViewCell.self)) { row, item, cell in
                cell.setTitle(item.title, image: item.image)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBinding()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
