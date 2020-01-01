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
    
    var completionAction: ((_ sort:SortType) -> Void)?
    
    // MARK: - Button Action
     
     @IBAction func closeAction() {
        if let action = completionAction {
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
            .map { _ in
                self.priceView.selected(true)
            }
            .subscribe(onNext: { _ in
                self.distanceView.selected(false)
            })
            .disposed(by: disposeBag)
        
        distanceView.tapItem()
            .map {_ in
                self.distanceView.selected(true)
            }
            .subscribe(onNext: { _ in
                self.priceView.selected(false)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
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
        self.initialize()
    }

}
