//
//  CamHttpSession.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/17.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import CloudCCTVSDK
import Alamofire
import SwiftyJSON

class CamHttpSession: NSObject {
    static let cctvSDK: CloudCCTVSDK = {
        return CloudCCTVSDK()
    }()
    
    func login(completion:@escaping (Bool)->()) {
        
    }
    
    func getCamID(email:String, lotSid:String, isRegular:Bool ,complition:@escaping ([String]?)->()){
    }
    
    func getCamLiveURL(camId:String, complition:@escaping (String?)->()){
    }
}
