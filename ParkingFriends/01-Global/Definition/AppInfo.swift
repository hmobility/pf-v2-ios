//
//  Definition.swift
//  ParkingFriends
//
//  Created by mkjwa on 2019/10/21.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

struct AppInfo {
    static let mapKey = "pcrrty836m"
    static let serviceKey = "parking_friends_key_matching_with_server"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let osType = "iOS"
    static let device = "iPhone"
}
