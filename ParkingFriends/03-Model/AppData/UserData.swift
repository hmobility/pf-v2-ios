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
    var filter: FilterOption = FilterOption()
    
    var displayPaymentGuide: Bool?
    
    private var basis: ProductOption = ProductOption()
    /*
    var reservableStartTime: Date  {
        get {
            return start ?? today
        }
    }
    
    var reservableEndTime: Date {
        get {
            return end ?? today.adjust(.hour, offset: 2)
        }
    }
    
    private var start: Date?
    private var end: Date?
    
    private var today: Date {
        get {
            var start = Date().dateFor(.nearestMinute(minute:10))
            
            if Date().compare(.isLater(than: start)) == true {
                start = start.adjust(.minute, offset: 10)
            }
            
            return start
        }
    }
    */
    // MARK: - Public Methods
    
    // MARK: - Product
    
    public func getProductType() -> ProductType {
        return basis.selectedProductType
    }
    
    public func setProduct(type:ProductType) -> UserData {
         basis.selectedProductType = type
         return self
    }
    
    // MARK: - Order Type
    
    public func getSortType() -> SortType {
        return filter.sortType
    }
      
    public func setSort(type:SortType) -> UserData {
        filter.sortType = type
        return self
    }
    
    // MARK: - Reservable Time
    
    public func getReservableDate() -> (start:Date, end:Date)  {
        return (basis.reservableStartTime, basis.reservableEndTime)
    }
    
    public func getReservableTime() -> (start:String, end:String) {
        let start = basis.reservableStartTime.toString(format: .custom("HHmm"))
        let end = basis.reservableEndTime.toString(format: .custom("HHmm"))
        
        return (start, end)
     }
    
    public func setReservableTime(start startDate:Date, end endDate:Date? = nil) {
        self.basis.start = startDate
        
        if let date = endDate {
            self.basis.end = date
        }
    }
    
    // MARK: - Auth
    
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
        self.displayPaymentGuide = nil
        self.basis = ProductOption()
        
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
        self.basis = aDecoder.decodeObject(forKey: "productOption") as? ProductOption ?? ProductOption()
        
        self.displayPaymentGuide = aDecoder.decodeObject(forKey: "displayPaymentGuide") as? Bool ?? true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey:"login")
        aCoder.encode(filter, forKey: "filter")
        aCoder.encode(basis, forKey: "productOption")
        
        aCoder.encode(displayPaymentGuide, forKey: "displayPaymentGuide")
    }
    
    static var shared:UserData {
        if UserData.sharedManager == nil {
            UserData.sharedManager = UserData().load() ?? UserData()
        }
        
        return UserData.sharedManager
    }
    
    private static var sharedManager:UserData!
}
