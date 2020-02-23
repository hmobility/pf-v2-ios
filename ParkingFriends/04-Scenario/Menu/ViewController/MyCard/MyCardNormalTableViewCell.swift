//
//  ExtraCardTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MyCardNormalTableViewCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    var selectAsDefaultAction: ((_ flag:Bool) -> Void)?
    var removeAction: ((_ flag:Bool) -> Void)?
    
    private var localizer:LocalizerType = Localizer.shared
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupButtonBinding() {
        localizer.localized("btn_default_card_change")
            .drive(switchButton.rx.title())
            .disposed(by: disposeBag)
        
        localizer.localized("btn_remove")
            .drive(removeButton.rx.title())
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                if let action = self.removeAction {
                    action(true)
                }
            })
            .disposed(by: disposeBag)
        
        switchButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                if let action = self.selectAsDefaultAction {
                    action(true)
                }
            })
            .disposed(by: disposeBag)
    }
     
    // MARK: - Initiailize
    
     
    func initialize() {
        setupButtonBinding()
    }
    
    // MARK: - Public Methods
    
    public func configure(title:String, cardNumber:String) {
        cardNameLabel.text = title
        cardNumberLabel.text = cardNumber
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
