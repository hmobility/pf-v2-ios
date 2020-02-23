//
//  BasicCardTableViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MyCardDefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var defaultCardTagButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var defaultButton: UIButton!
    
    var removeAction: ((_ flag:Bool) -> Void)?
    
    private var localizer:LocalizerType = Localizer.shared
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupButtonBinding() {
       localizer.localized("txt_basic_card")
           .drive(defaultCardTagButton.rx.title())
           .disposed(by: disposeBag)
       
       localizer.localized("btn_remove")
           .drive(removeButton.rx.title())
           .disposed(by: disposeBag)
       
       localizer.localized("btn_my_card_default")
           .drive(defaultButton.rx.title())
           .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                if let action = self.removeAction {
                    action(true)
                }
            })
            .disposed(by: disposeBag)
    }
     
    // MARK: - Initiailize
     
    private func initialize() {
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
