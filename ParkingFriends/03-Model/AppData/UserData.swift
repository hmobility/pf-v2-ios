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
    var filter:FilterOption = FilterOption()
    var noDiplayPaymentGuide:Bool?
    var productOption:ProductOption?
    
    // MARK: - Public Methods
    
    public func setAuth(_ data:Login?) -> UserData {
        guard data != nil else {
            return self
        }
        
        self.login = data
        
        return self
    }
    
    public func setToken(access:String?, refresh:String?) {
        if let login = login, let accessToken = access, let refreshToken = refresh {
            login.accessToken = accessToken
            login.refreshToken = refreshToken
            save()
        }
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
    
    public func logout() {
        self.reset()
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let target = Storyboard.splash.instantiateInitialViewController() as! SplashViewController
            window.rootViewController = target
        }
    }
    
    // Usually call this method in AppDelegate
    public func initiated(_ lang:Language = .korean) {
        self.language(lang)
    }
    
    // MARK: - Local Methods
    
    private func reset() {
        self.login = nil
        self.filter = FilterOption()
        self.noDiplayPaymentGuide = nil
        self.productOption = nil
        
        save()
    }
    
    private func load(_ lang:Language = .korean) -> UserData? {
        self.language(lang)
            
        if let data = UserDefaults.standard.object(forKey: "User") {
            let archive = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! UserData
           
            return archive
        }

        return nil
    }
    
    // MARK: - Initialize

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.login = aDecoder.decodeObject(forKey: "login") as? Login
        self.filter = aDecoder.decodeObject(forKey: "filter") as! FilterOption
        self.noDiplayPaymentGuide = aDecoder.decodeObject(forKey: "noDiplayPaymentGuide") as? Bool ?? false
        self.productOption = aDecoder.decodeObject(forKey: "productOption") as? ProductOption
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey:"login")
        aCoder.encode(filter, forKey: "filter")
        aCoder.encode(noDiplayPaymentGuide, forKey: "noDiplayPaymentGuide")
        aCoder.encode(productOption, forKey: "noDiplayPaymentGuide")
    }
    
    static var shared:UserData {
        if UserData.sharedManager == nil {
            UserData.sharedManager = UserData().load() ?? UserData()
        }
        
        return UserData.sharedManager
    }
    
    private static var sharedManager:UserData!
}
