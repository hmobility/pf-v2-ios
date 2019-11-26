//
//  UserData.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/21.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

class UserData: NSObject, NSCoding {
    var login: Login?
    
    override init() {
       super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.login = aDecoder.decodeObject(forKey: "login") as? Login
     //  self.userName = aDecoder.decodeObject(forKey: "userName") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey:"login")
     //   aCoder.encode(userName, forKey: "userName")

    }
    
    public func setAuth(_ data:Login?) -> UserData {
        guard data != nil else {
            print("[User Data] Login Data is null" )
            return self        }
        
        self.login = data
        
        return self
    }
    
    public func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "User")
        UserDefaults.standard.synchronize()
    }
    
    public func language(_ language:Language) {
        let code = language.rawValue
        Localizer.shared.changeLanguage.accept(code)
    }
      
    public func load(_ lang:Language = .korean) -> UserData? {
        self.language(lang)
            
        if let data = UserDefaults.standard.object(forKey: "User") {
            let archive = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! UserData
            
            return archive
        }

        return nil
    }
    
    // Usually call this method in AppDelegate
    
    public func initiated() {
        if let _ = self.load() {
        }
    }
    
    // MARK: - Initialize
    
    static var shared:UserData {
        if UserData.sharedManager == nil {
            UserData.sharedManager = UserData()
        }
        
        return UserData.sharedManager
    }
    
    private static var sharedManager:UserData!
}
