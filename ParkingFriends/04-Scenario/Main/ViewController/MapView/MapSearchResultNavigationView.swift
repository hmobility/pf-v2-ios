//
//  MapSearchResultNavigationBar.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/10.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MapSearchResultNavigationView: UIStackView {
    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var searchOrderLabel: UILabel!
    
    private var titleView:NavigationTitleView = NavigationTitleView()
     
    // MARK: - Public Methods
    
    public func setTitle(_ text:String) {
        titleView.titleLabel.text = text
    }
    
    public func setSubtitle(_ text:String) {
        titleView.subtitleLabel.text = text
    }
    
    public func setSearchOrder(_ text:String) {
        searchOrderLabel.text = text
    }
    
    public func show() {
        if self.isHidden {
            self.isHidden = false
        }
    }
    
    public func hide() {
        if !self.isHidden {
            self.isHidden = true
        }
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationBar.topItem {
            topItem.titleView = titleView
            titleView.titleColor = Color.darkGrey
            titleView.titleFont = Font.gothicNeoMedium16
            titleView.subtitleColor = Color.darkGrey
            titleView.subtitleFont = Font.helvetica12
        }
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        initialize()
    }

}
