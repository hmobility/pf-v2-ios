//
//  AppConfig.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Firebase
import Fabric
import Crashlytics
import NMapsMap

class AppConfig: NSObject {
    
    override init() {
        super.init()
    }
    
    public func apply() {
        FirebaseApp.configure(options: GoogleServiceFileOptions!)
        Fabric.with([Crashlytics.self])
        
        NMFAuthManager.shared().clientId = AppInfo.mapKey
    }

    // MARK: - Initialize
    
    static var shared:AppConfig {
        if AppConfig.sharedManager == nil {
            AppConfig.sharedManager = AppConfig()
        }
        
        return AppConfig.sharedManager
    }
    
    private static var sharedManager:AppConfig!
}
