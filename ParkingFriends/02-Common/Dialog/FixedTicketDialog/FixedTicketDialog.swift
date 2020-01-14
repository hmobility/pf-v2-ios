//
//  FixedTicketDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

public struct FixedTicketDialog {
    static func show(source:UIViewController, start:Date, handler:((_ start: Date, _ hours: Int) -> Void)?) {
        let target = Dialog.fixedTicket.instantiateViewController(withIdentifier: "FixedTicketNavigationController") as! FixedTicketNavigationController
        
        target.setStart(date: start)
    
        target.completeAction = { (start, hours) in
            if let completion = handler {
                completion(start, hours)
            }
        }
        
        let segue = SwiftMessagesSegue(identifier: nil, source: source, destination: target)
        segue.configure(layout: .bottomMessage)
        segue.perform()
    }
}
