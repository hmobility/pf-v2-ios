//
//  ReservedNoticeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import SwiftMessages

class ReserveNoticeView: MessageView {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var cancel: (() -> Void)?
    var done: ((_ id:String) -> Void)?
    
    // MARK: - Button Action
    
    @IBAction func cancelAction() {
        cancel?()
    }
    
    @IBAction func doneAction() {
        done?("")
    }
    
    // MARK: - Initialize
    
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
