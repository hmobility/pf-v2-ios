//
//  OrderView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import SwiftMessages

class SortOrderDialogView: MessageView {
    @IBOutlet weak var priceView: CustomSortItemView!
    @IBOutlet weak var distanceView: CustomSortItemView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var sortType:SortType = .price
    
    private let disposeBag = DisposeBag()
    
    var completeAction: ((_ sort:SortType) -> Void)?
    
    // MARK: - Button Action
     
    @IBAction func closeAction() {
        if let action = completeAction {
            action(self.sortType)
        }
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        priceView.tapItem()
            .subscribe(onNext: { type in
                self.distanceView.selected(false)
                self.updateSelectedItem(type)
            })
            .disposed(by: disposeBag)
        
        distanceView.tapItem()
            .subscribe(onNext: { type in
                self.priceView.selected(false)
                self.updateSelectedItem(type)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func updateSelectedItem(_ item:SortType) {
        sortType = item
    }
    
    private func selectItem(_ type:SortType) {
        priceView.selected((type == .price))
        distanceView.selected((type == .distance))
    }
    
    // MARK: - Public Methods
    
    public func setSortType(_ type:SortType) {
        sortType = type
        selectItem(type)
    }
    
    public func setItems(_ items:[String], selected:SortType) {
        priceView.setItem(title: items[0], value: .price, selected: (selected == .price))
        distanceView.setItem(title: items[1], value: .distance, selected: (selected == .distance))
    }
    
    // MARK: - Drawings
      
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

}
