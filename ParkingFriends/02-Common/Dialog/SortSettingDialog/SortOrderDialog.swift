//
//  SequenceOrderDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

public struct SortOrderDialog {
    static func show(selected sortType:SortType = .distance, title:String = Localizer.shared.localized("ttl_sort_order"), items:[String] = [ Localizer.shared.localized("itm_sort_price"), Localizer.shared.localized("itm_sort_distance")], done:String = Localizer.shared.localized("btn_close"), handler: ((_ done:Bool, _ sort: SortType?) -> Void)?) {
        let view:SortOrderDialogView = try! SwiftMessages.viewFromNib()
        
        view.setSortType(sortType)
        
        view.backgroundView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        
        view.configureContent(title: title, body: nil, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: done, buttonTapHandler: nil)
        
        view.completeAction = { (sort) in
            if let handler = handler {
                handler(true, sort)
            }
            
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
