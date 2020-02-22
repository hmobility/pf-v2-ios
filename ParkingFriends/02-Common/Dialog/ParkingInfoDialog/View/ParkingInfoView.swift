//
//  ParkingInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

enum ParkingInfoDialogType {
    case none, customer_center, report_parking
}

class ParkingInfoView: MessageView {
    @IBOutlet weak var firstItemView: ParkingInfoItemView!
    @IBOutlet weak var seconItemView: ParkingInfoItemView!
    @IBOutlet weak var closeButton: UIButton!
    
    var completeAction: ((_ item:ParkingInfoDialogType) -> Void)?
    
    var cancelAction: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
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
        firstItemView.tapItem()
            .subscribe(onNext: { type in
             
            })
            .disposed(by: disposeBag)
        
        seconItemView.tapItem()
            .subscribe(onNext: { type in
           
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                if let action = self.cancelAction {
                    action()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Public Methods
    
    public func setItems(_ items:[(type:ParkingInfoDialogType, title:String)]) {
        firstItemView.setItem(title: items[0].title, value: items[0].type)
        seconItemView.setItem(title: items[1].title, value: items[1].type)
    }
    
    // MARK: - Drawings
      
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

}
