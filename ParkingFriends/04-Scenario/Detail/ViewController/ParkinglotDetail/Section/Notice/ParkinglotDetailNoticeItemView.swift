//
//  ParkinglotDetailNoticeItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/31.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailNoticeItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    public func setContent(_ item:String) {
        _ = Observable.of(item)
                .map ({ text in
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = 3
                    paragraph.headIndent = 12
            
                    return  NSMutableAttributedString(string: text,
                                attributes:[NSAttributedString.Key.foregroundColor: Color.slateGrey,
                                            NSAttributedString.Key.font: Font.gothicNeoRegular15,
                                                NSAttributedString.Key.paragraphStyle:paragraph])
                })
                .bind(to: titleLabel.rx.attributedText)
                .disposed(by: disposeBag)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
