//
//  TicketTapView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/14.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkingTicketTapView: UIView {
    @IBOutlet var tapButtons: [UIButton]!
    
    private var items:[(title:String, type:ProductType)] = []
    private var selectedType:ProductType = .fixed
    
    private let disposeBag = DisposeBag()

    // MARK: - Public Methods
    
    public func setItems(_ items:[(title:String, type:ProductType)]) {
        self.items = items
    }
    
    public func setSelectedProductType(_ type:ProductType) {
        
    }

    // MARK: - Local Methods
    
    func updateState() {
        for (index, item) in tapButtons.enumerated() {
            let result = (items[index].type == selectedType)
           
            if item.isSelected != result {
                item.isSelected = result
            }
        }
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        let selectedButton = Observable.from(
                    tapButtons.map { button in
                        button.rx.tap.map { button }
                    })
                    .merge()
        
        tapButtons.reduce(Disposables.create()) { disposable, button in
                let subscription = selectedButton.map { $0 == button }
                    .bind(to: button.rx.isSelected)
                return Disposables.create(disposable, subscription)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Drawings
      
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBinding()
    }
    
    // MARK: - Initializers
      
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
