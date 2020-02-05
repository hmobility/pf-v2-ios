//
//  SearchHistoryFooterView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class SearchHistoryFooterView: UIView {
    @IBOutlet weak var removeButton: UIButton!
    
    private var titleString:String?
    
    // MARK: - Public Methods
    
    public func setTitle(_ title:String) {
        titleString = title
    }

    // MARK: - Local Methods

    private func updateLayout() {
        if let title = titleString {
            let attributedString = NSMutableAttributedString(string: title,
                                    attributes:[NSAttributedString.Key.foregroundColor: Color.slateGrey,
                                                NSAttributedString.Key.font: Font.gothicNeoRegular15,
                                                NSAttributedString.Key.underlineStyle:1.0])
            removeButton.setAttributedTitle(attributedString, for: .normal)
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        updateLayout()
    }
}
