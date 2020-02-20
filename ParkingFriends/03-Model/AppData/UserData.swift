//
//  UserData.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/21.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import ObjectMapper

let kBookingTimeFormat = "yyyyMMddHHmm"

class UserData: NSObject, NSCoding {
    var login: Login? {
        didSet {
            memberInfo.load()
        }
    }
    
    var filter: FilterOption = FilterOption()
    var displayPaymentGuide: Bool = true
    
    var productSettings:ProductSetting = ProductSetting.shared
    var searchHistory:SearchHistory = SearchHistory.shared
    var memberInfo:MemberInfo = MemberInfo.shared

    // MARK: - Public Methods
    /*
    // MARK: - Product
    // Deprecated
    public func getProductType() -> ProductType {
        return productSettings.selectedProductType
    }
    // Deprecated
    public func setProduct(type:ProductType) -> ProductSetting {
         productSettings.selectedProductType = type
         return productSettings
    }
    */
    // MARK: - Order Type
    
    public func getSortType() -> SortType {
        return filter.sortType
    }
      
    public func setSort(type:SortType) -> UserData {
        filter.sortType = type
        return self
    }
    
    // MARK: - Reservable Time
    
    public func getOnReserveDate() -> DateDuration  {
        return (productSettings.bookingStartTime, productSettings.bookingEndTime)
    }
    
    public func getOnReserveTime() -> (start:String, end:String) {
        let start = productSettings.bookingStartTime.toString(format: .custom(kBookingTimeFormat))
        let end = productSettings.bookingEndTime.toString(format: .custom(kBookingTimeFormat))
        
        return (start, end)
     }
    
    public func setOnReserveTime(start startDate:Date, end endDate:Date? = nil) {
        productSettings.setBookingTime(start: startDate, end: endDate)
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
        
        let target = Storyboard.splash.instantiateInitialViewController() as! SplashViewController
        target.makeWindowRoot()
    }
    
    // Usually call this method in AppDelegate
    public func initiated(_ lang:Language = .korean) {
        self.language(lang)
    }
    
    // MARK: - Local Methods
    
    private func reset() {
        self.login = nil
        self.filter = FilterOption()
        self.displayPaymentGuide = true
        self.productSettings = ProductSetting()
        
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
     //   self.basis = aDecoder.decodeObject(forKey: "productOption") as? ProductOption ?? ProductOption()
        
        self.displayPaymentGuide = aDecoder.decodeObject(forKey: "displayPaymentGuide") as? Bool ?? true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey:"login")
        aCoder.encode(filter, forKey: "filter")
       // aCoder.encode(basis, forKey: "productOption")
        
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
