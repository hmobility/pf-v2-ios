//
//  ColorDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

public struct ColorDialog {
    static func show(selected:ColorType = ColorType.white, title:String = Localizer.shared.localized("ttl_color_picker"), done:String = Localizer.shared.localized("btn_to_save"), handler: ((_ done:Bool, _ color: ColorType?) -> Void)?) {
        let view:ColorDialogView = try! SwiftMessages.viewFromNib()
        view.backgroundView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        view.configureContent(title: title, body: nil, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: done) { _ in
            SwiftMessages.hide()
        }
        
        view.cancelAction = { () in
            if let _ = handler {
                handler!(false, nil)
            }
        }
        
        view.completionAction = { color in
            if let _ = handler {
                handler!(true, color)
            }
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .color(color: #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1254901961, alpha: 0.6), interactive: true)
        
        SwiftMessages.show(config: config, view: view)
    }
}
