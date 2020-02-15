//
//  SearchHistory.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import Foundation

private let limitedOfNumber = 5

class SearchHistory: NSObject, NSCoding {
    private var historyItems:[String] = []
    
    // MARK: - Public Methods
    
    public func getItems() -> [String]? {
        return historyItems.reversed()
    }
    
    public func resetAll() -> [String]? {
        historyItems = []
        save()
        
        return historyItems
    }
    
    public func addItem(_ item:String) -> [String]? {
        guard historyItems.contains(item) == false else {
            return historyItems
        }
        
        historyItems.append(item)
        
        if historyItems.count > limitedOfNumber {
            historyItems.removeLast()
        }
        
        save()
        
        return historyItems
    }
    
    public func removeItem(with index:Int) -> [String]?  {
        if index < historyItems.count {
            historyItems.remove(at: index)
        }
        
        return historyItems
    }
    
    // MARK: - Local Methods
    
    private func load(_ lang:Language = .korean) -> SearchHistory? {
          if let data = UserDefaults.standard.object(forKey: "UserHistory") {
              let archive = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! SearchHistory
             
              return archive
          }

          return nil
      }
    
    public func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "UserHistory")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Encoding/Decoding
    
    required init(coder aDecoder: NSCoder) {
        historyItems = aDecoder.decodeObject(forKey: "historyItems") as? [String] ?? []
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(historyItems, forKey: "historyItems")
    }
    
    // MARK: - Initialize

    override init() {
        super.init()
    }
    
    static var shared:SearchHistory {
        if SearchHistory.sharedManager == nil {
            SearchHistory.sharedManager = SearchHistory().load() ?? SearchHistory()
        }
        
        return SearchHistory.sharedManager
    }
    
    private static var sharedManager:SearchHistory!
}
