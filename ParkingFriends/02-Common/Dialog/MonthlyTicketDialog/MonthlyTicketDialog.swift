//
//  MonthlyTicketDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/13.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

public struct MonthlyTicketDialog {
    static func show(source:UIViewController, start:Date, handler:((_ start: Date, _ months: Int) -> Void)?) {
        let target = Dialog.monthlyTicket.instantiateViewController(withIdentifier: "MonthlyTicketNavigationController") as! MonthlyTicketNavigationController
        
        target.setStart(date: start)
    
        target.completeAction = { (start, months) in
            if let completion = handler {
                completion(start, months)
            }
        }
        
        let segue = SwiftMessagesSegue(identifier: nil, source: source, destination: target)
        segue.configure(layout: .bottomMessage)
        segue.perform()
    }
}
