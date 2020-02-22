//
//  ParkingInfoDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


public struct ParkingInfoDialog {
    static func show(_ title:String = Localizer.shared.localized("ttl_navigation_guide"), text:String, close:String = Localizer.shared.localized("btn_close"), handler: ((_ done:Bool, _ sort: ParkingInfoDialogType?) -> Void)?)  {
        let view:ParkingInfoView = try! SwiftMessages.viewFromNib()
        
        //  view.setSortType(sortType)
        
        view.backgroundView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        
        //     view.configureContent(title: title, body: nil, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: done, buttonTapHandler: nil)
        
        view.configureContent(title: title, body: nil, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil) { _ in
            SwiftMessages.hide()
        }
        
        view.completeAction = { (item) in
            if let handler = handler {
                handler(true, item)
            }
        }
        
        view.cancelAction = { () in
            SwiftMessages.hide()
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .color(color: #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1254901961, alpha: 0.6), interactive: true)
        
        SwiftMessages.show(config: config, view: view)
    }
}
