//
//  RserveNoticeDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

public struct ReserveNoticeDialog {
    static func show(_ title:String, text:String, done:String = Localizer.shared.localized("btn_to_move"), cancel:String = Localizer.shared.localized("btn_cancel"), icon:IconType = .notice) {
        let view:ReserveNoticeView = try! SwiftMessages.viewFromNib()
        view.backgroundView.backgroundColor = Color.charcoalGrey
        view.configureDropShadow()
        
        view.configureContent(title: title, body: nil, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil) { _ in
            SwiftMessages.hide()
        }
        
        view.done = { (result) in
        }
    
        view.cancel = { () in
             SwiftMessages.hide()
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .forever
        config.presentationStyle = .top
        config.preferredStatusBarStyle = .lightContent
        
        SwiftMessages.show(config: config, view: view)
    }
}
