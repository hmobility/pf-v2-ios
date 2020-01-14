//
//  TimeTicketDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

public struct TimeTicketDialog {
    static func show(source:UIViewController, start:Date, handler:((_ start:Date, _ end:Date) -> Void)?) {
        let target = Dialog.timeTicket.instantiateViewController(withIdentifier: "TimeTicketNavigationController") as! TimeTicketNavigationController
        
        target.setStart(date: start)
    
        target.completeAction = { (start, end) in
            if let completion = handler {
                completion(start, end)
            }
        }
        
        let segue = SwiftMessagesSegue(identifier: nil, source: source, destination: target)
        segue.configure(layout: .bottomMessage)
        segue.perform()
    }
}
