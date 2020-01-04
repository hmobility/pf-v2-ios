//
//  TimeTicketDialog.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


import Foundation

public struct TimeTicketDialog {
    static func show(source:UIViewController) {
        let target = Storyboard.timeTicketDialog.instantiateViewController(withIdentifier: "TimeTicketNavigationController") as! TimeTicketNavigationController
        let segue = SwiftMessagesSegue(identifier: nil, source: source, destination: target)
        segue.configure(layout: .bottomMessage)
        segue.perform()
    }
}
