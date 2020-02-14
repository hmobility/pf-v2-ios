//
//  ParkinglotDetailFixedControlView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailFixedControlView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var contentsView: UIStackView!
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType = Localizer.shared
    private var checkButtonArray:[UIButton] = []
    
    // MARK: - Binding

    
    // MARK: - Public Methods

    public func updateTimeCheckItemView(with title:String)  {
        let itemView = ParkinglotDetailFixedTimeCheckView.loadFromXib() as ParkinglotDetailFixedTimeCheckView
        itemView.setTitle(title)
        contentsView.addArrangedSubview(itemView)
    }

    // MARK: - Local Methods

    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
     //   setupItemBinding()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    }
}
