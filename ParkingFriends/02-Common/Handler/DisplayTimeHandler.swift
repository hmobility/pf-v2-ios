//
//  DisplayTimeHandler.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/11.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import AFDateHelper

struct DisplayTimeHandler {
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    // MARK: - Private Method
    
    private func getAmPmString(_ date:Date) -> String {
        return (date.toString(format:(.custom("a"))) == "AM") ? localizer.localized("txt_am") : localizer.localized("txt_pm")
    }
    
    // MARK: - Public Method
    
    func displayReservableTime(start:Date, end:Date) -> String {
        let startAmPm:String = getAmPmString(start)
        let startTime:String = start.toString(format:(.custom("h:m")))
        
        let endTime:String = end.toString(format:(.custom("h:m")))
        let endAmPm:String = getAmPmString(end)
        
        let duration = end.since(start, in: .hour)
        
        return"\(startAmPm) \(startTime) - \(endAmPm) \(endTime) (\(duration)\(localizer.localized("txt_hours")))"
    }
    
    // For dialog of reservable time selection
    func diplayTimeTicketFromDate(date:Date) -> String {
        let day:String = date.compare(.isToday) ? localizer.localized("txt_today") : "\(date.toString(format:(.custom("M")))):\(date.toString(format:(.custom("d"))))"
        
        let amPm:String = (date.toString(format:(.custom("a"))) == "AM") ? localizer.localized("txt_am") : localizer.localized("txt_pm")
        
        let time:String = date.toString(format:(.custom("h:m")))
        
        return "\(day)\(localizer.localized("txt_from")) \(amPm) \(time)"
    }
    
    // For dialog of reservable time selection
    func diplayFixedTicketFromDate(date:Date, hours:Int) -> String {
        let day:String = date.compare(.isToday) ? localizer.localized("txt_today") : "\(date.toString(format:(.custom("M")))):\(date.toString(format:(.custom("d"))))"
        
        return "\(day),\(localizer.localized("txt_fixed_ticket_day")) \(hours) \(localizer.localized("txt_hours"))"
    }
}
