//
//  CustomNavigationItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class NavigationTitleView: UIView {
    private var contentStackView = UIStackView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()

    var titleColor: UIColor = .black {
        didSet(newValue) {
            titleLabel.textColor = newValue
        }
    }
    
    var subTitleColor: UIColor = .black {
        didSet(newValue) {
            subTitleLabel.textColor = newValue
        }
    }
    
    var titleFont: UIFont? {
        didSet(newValue) {
            titleLabel.font = newValue
        }
    }
    
    var subTitleFont: UIFont? {
        didSet(newValue) {
            subTitleLabel.font = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        viewConfig()
        addViewsConfig()
        layoutViewsConfig()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String, subTitle: String){
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }

    private func viewConfig() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.distribution  = .fill
        contentStackView.spacing = 4

        self.backgroundColor = .clear
        self.titleLabel.textColor = titleColor
        self.subTitleLabel.textColor = subTitleColor
        
        if let font = titleFont {
            self.titleLabel.font = font
        }
        
        if let font = subTitleFont {
            self.subTitleLabel.font = font
        }
    }

    private func addViewsConfig() {
        contentStackView.addArrangedSubview(subTitleLabel)
        contentStackView.addArrangedSubview(titleLabel)
        self.addSubview(contentStackView)
    }

    private func layoutViewsConfig(){
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
    }
}
