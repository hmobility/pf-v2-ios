//
//  FirebaseType.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/15.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Firebase

protocol AnalyticsType {
    var screenName:String { get }
}

typealias KeyWords = [String : Any]

extension AnalyticsType {
    var screenClass:String {
        return String(describing: type(of: self))
    }
    
    var screenName:String {
        return screenClass
    }
    
    func trackScreen() {
        Analytics.setScreenName(screenName, screenClass: screenClass)
    }
    
    func track(_ name:String, _ params:KeyWords) {
        Analytics.logEvent(name, parameters: params)
    }
    
    func track(_ content:String, forName name:String) {
        Analytics.setUserProperty(content, forName: name)
    }
    
    /*
     Firebase Reserved Events
     ex)AnalyticsEventSelectContent, [AnalyticsParameterItemID: "id-\(screenName)",
         AnalyticsParameterItemName: screenName,
         AnalyticsParameterContentType: "cont"]
    */
    func track(event:String, _ params:KeyWords) {
        Analytics.logEvent(event, parameters:params)
    }
    
    func trackLog() {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(screenName)",
            AnalyticsParameterItemName: screenName,
            AnalyticsParameterContentType: "cont"
        ])
        
        Analytics.logEvent("share_image", parameters: [
            "name": "test_name" as NSObject,
            "full_text": "test_text" as NSObject
        ])
        
        Analytics.setUserProperty("food", forName: "favorite_food")
    }
}
