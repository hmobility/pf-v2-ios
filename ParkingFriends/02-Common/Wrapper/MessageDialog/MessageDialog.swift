//
//  Message.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import SwiftMessages

enum IconType: String {
    case warning = "icWarningFillCircleRed"
    case success = "icSuccessGreen"
    
    public var image: UIImage {
        return UIImage(named: rawValue)!
    }
}

public struct MessageDialog {
    static func show(_ text:String, duration:TimeInterval = 3, icon:IconType = .warning) {
        let view:CustomDialogView = try! SwiftMessages.viewFromNib()
        view.backgroundView.backgroundColor = Color.charcoalGrey
        view.backgroundColor = Color.charcoalGrey
        view.configureContent(title: nil, body: text, iconImage: icon.image, iconText: nil, buttonImage: nil, buttonTitle: nil) { _ in
            SwiftMessages.hide()
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .seconds(seconds: duration)
        config.presentationStyle = .top
        config.preferredStatusBarStyle = .lightContent
        
        SwiftMessages.show(config: config, view: view)
    }
}
