//
//  ProductOption.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/17.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Foundation

protocol ProductSettingType {
    func getProductType() -> ProductType
    func setProduct(type:ProductType) -> ProductSetting
    func getBookingDate() -> DateDuration
    func getBookingTime() -> (start:String, end:String)
    func setBookingTime(start startDate:Date, end endDate:Date?)
    func setBookingMonthly(from startDate:Date, count:Int)
    func getBookingMonthly() -> (from:String, count:Int)
}

class ProductSetting: NSObject, NSCoding, ProductSettingType {
    var selectedProductType:ProductType = .fixed
    
    var bookingMonthly:(from: Date, count: Int) {
        get {
            return (monthlyFrom ?? today, monthlyCount)
        }
    }
    
    var bookingStartTime: Date  {
        get {
            return start ?? today
        }
    }
    
    var bookingEndTime: Date {
        get {
            return end ?? today.adjust(.hour, offset: 2)
        }
    }
    
    private var monthlyFrom:Date?
    private var monthlyCount:Int = 1
       
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
    
    // MARK: - Public Methods
    
    public func getProductType() -> ProductType {
         return self.selectedProductType
     }
     
     public func setProduct(type:ProductType) -> ProductSetting {
          self.selectedProductType = type
          return self
     }
    
    public func getBookingDate() -> DateDuration  {
        return (self.bookingStartTime, self.bookingEndTime)
    }
    
    // MARK: - Monthly Ticket
    
    public func getBookingMonthly() -> (from:String, count:Int) {
        let start = self.bookingMonthly.from.toString(format: .custom(kBookingTimeFormat))
        
        return (from: start, count: self.bookingMonthly.count)
    }
    
    public func setBookingMonthly(from startDate:Date, count:Int) {
        monthlyFrom = startDate
        monthlyCount = count
    }
    
    // MARK: - Time/Fixed Ticket
    
    public func setBookingTime(start startDate:Date, end endDate:Date? = nil) {
        self.start = startDate
        
        if let date = endDate {
            self.end = date
        }
    }
    
    public func getBookingTime() -> (start:String, end:String) {
        let start = self.bookingStartTime.toString(format: .custom(kBookingTimeFormat))
        let end = self.bookingEndTime.toString(format: .custom(kBookingTimeFormat))
        
        return (start, end)
    }
    
    // MARK: - Local Methods
    
    private func load(_ lang:Language = .korean) -> ProductSetting? {
        if let data = UserDefaults.standard.object(forKey: "ProductSetting") {
            let archive = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProductSetting
            
            return archive
        }
        
        return nil
    }
    
    public func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "ProductSetting")
        UserDefaults.standard.synchronize()
    }
    
    public func reset() {
        ProductSetting.sharedManager = ProductSetting()
        
        save()
    }
    
    // MARK: - Encoding/Decoding

    required init(coder aDecoder: NSCoder) {
        monthlyFrom = aDecoder.decodeObject(forKey: "monthlyFrom") as? Date ?? Date()
        monthlyCount = aDecoder.decodeObject(forKey: "monthlyCount") as? Int ?? 1
        selectedProductType = ProductType(rawValue: aDecoder.decodeObject(forKey: "selectedProductType") as! String) ?? .time
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(monthlyFrom, forKey: "monthlyFrom")
        aCoder.encode(monthlyCount, forKey: "monthlyCount")
        aCoder.encode(selectedProductType.rawValue, forKey: "selectedProductType")
    }
    
    // MARK: - Initialize
    
    override init() {
         super.init()
     }
    
    static var shared:ProductSetting {
        if ProductSetting.sharedManager == nil {
            ProductSetting.sharedManager = ProductSetting().load() ?? ProductSetting()
        }
        
        return ProductSetting.sharedManager
    }
    
    private static var sharedManager:ProductSetting!
}
