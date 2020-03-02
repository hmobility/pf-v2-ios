//
//  PaymentMethodView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/30.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol PaymentMethodViewType {
    
}

enum PaymentMethodButtonType {
    case simple_card, kakopay
}

class PaymentMethodView: UIStackView, PaymentMethodViewType {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var simpleCardButton: UIButton!
    @IBOutlet weak var kakaoPayButton: UIButton!
    
    var viewModel: PaymentMethodViewModelType = PaymentMethodViewModel()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupButtonBinding() {
        let buttons = [simpleCardButton, kakaoPayButton].map { $0! }
        
        let selectedButton = Observable.from(buttons.map { button in
                                button.rx.tap.map { button }
                            })
                           .merge()
               
        buttons.reduce(Disposables.create()) { disposable, button in
                    let subscription = selectedButton.map { $0 == button }
                        .bind(to: button.rx.isSelected)
                    return Disposables.create(disposable, subscription)
                }
                .disposed(by: disposeBag)
        
        selectedButton.asObservable().map { button in
            
        }
    }
    
    // MARK: - Initialzie
    
    private func initialize() {
        setupButtonBinding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}
