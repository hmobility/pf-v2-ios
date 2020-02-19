//
//  DisplayTimeHandler.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/11.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import AFDateHelper

struct DisplayDateTimeHandler {
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    // MARK: - Private Method
    
    private func getAmPmString(_ date:Date) -> String {
        return (date.toString(format:(.custom("a"))) == "AM") ? localizer.localized("txt_am") : localizer.localized("txt_pm")
    }
    
    private func getDayOfTheWeek(_ name:String) -> String {
        switch name {
        case "Monday":
            return localizer.localized("itm_mon")
        case "Tuesday":
            return localizer.localized("itm_tue")
        case "Wednesday":
            return localizer.localized("itm_wed")
        case "Thursday":
            return localizer.localized("itm_thu")
        case "Friday":
            return localizer.localized("itm_fri")
        case "Saturday":
            return localizer.localized("itm_sat")
        case "Sunday":
            return localizer.localized("itm_sun")
        default:
            return ""
        }
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
    
    // For Operatim time
    func displayOperationTime(start:String, end:String) -> String {
        let startHours = start.first(char: 2).intValue
        let startMinutes = start.last(char: 2).intValue
        let startAmPm:String = (startHours < 12) ? localizer.localized("txt_am") : localizer.localized("txt_pm")
        let startTime = "\(startAmPm) " + ((startHours < 12 ) ? "\(startHours)" : "\(startHours % 12)") +  "\(localizer.localized("txt_hour_unit"))" + ((startMinutes > 0) ? "\(startMinutes)\(localizer.localized("txt_minute_unit"))" : "")
        
        let endHours = end.first(char: 2).intValue
        let endMinutes = end.last(char: 2).intValue
        let endAmPm:String = (endHours < 12) ? localizer.localized("txt_am") : localizer.localized("txt_pm")
        let endTime = "\(endAmPm) " + ((endHours < 12 ) ? "\(endHours)" : "\(endHours % 12)") + " \(localizer.localized("txt_hour_unit"))" + ((endMinutes > 0) ? "\(endMinutes)\(localizer.localized("txt_minute_unit"))" : "")
        
        return "\(startTime) ~ \(endTime)"
    }
    
    func displayDateYYmD(with date:Date) -> String {
        let dayName = getDayOfTheWeek(date.toString(format:(.custom("EEEE"))))
        let result:String = date.compare(.isToday) ? localizer.localized("txt_today") : "\(date.toString(format:(.custom("YY")))).\(date.toString(format:(.custom("M")))).\(date.toString(format:(.custom("d")))) \(dayName)"
        
        return result
    }
}
