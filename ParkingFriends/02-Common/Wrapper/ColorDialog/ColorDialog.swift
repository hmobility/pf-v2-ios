//
//  ColorDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

enum ColorType {
    case white, black, dark_gray, silver, blue, red, gold, blue_green, dark_green, brown, sky_blue
    
    var rawValue: String {
        switch self {
        case .white: return "itm_white"
        case .black: return "itm_black"
        case .dark_gray: return "itm_dark_gray"
        case .silver: return "itm_silver"
        case .blue: return "itm_blue"
        case .red: return "itm_red"
        case .gold: return "itm_gold"
        case .blue_green: return "itm_blue_green"
        case .dark_green: return "itm_dark_green"
        case .brown: return "itm_brown"
        case .sky_blue: return "itm_sky_blue"
        }
    }
    
    var imgValue: String {
        switch self {
        case .white: return "imgCarcolorPaletteWhite"
        case .black: return "imgCarcolorPaletteBlack"
        case .dark_gray: return "imgCarcolorPaletteDarkgray"
        case .silver: return "imgCarcolorPaletteSilver"
        case .blue: return "imgCarcolorPaletteBlue"
        case .red: return "imgCarcolorPaletteRed"
        case .gold: return "imgCarcolorPaletteGold"
        case .blue_green: return "imgCarcolorPaletteBluegreen"
        case .dark_green: return "imgCarcolorPaletteDarkgreen"
        case .brown: return "imgCarcolorPaletteBrown"
        case .sky_blue: return "imgCarcolorPaletteSkyblue"
        }
    }
    
    public var image: UIImage {
        return UIImage(named: imgValue)!
    }
}

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
