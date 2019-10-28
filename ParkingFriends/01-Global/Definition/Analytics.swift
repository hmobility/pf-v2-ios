//
//  Analytics.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/28.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Firebase


#if DEBUG
    let GoogleServiceFilePath = Bundle.main.path(forResource: "GoogleService-Info-Development", ofType: "plist")
#else
    let GoogleServiceFilePath = Bundle.main.path(forResource: "GoogleService-Info-Release", ofType: "plist")
#endif

let GoogleServiceFileOptions = FirebaseOptions(contentsOfFile:GoogleServiceFilePath!)
