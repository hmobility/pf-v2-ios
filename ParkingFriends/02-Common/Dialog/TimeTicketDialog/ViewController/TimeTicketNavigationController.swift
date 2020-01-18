//
//  TimeTicketNavigationController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class TimeTicketNavigationController: UINavigationController {
    
    var completeAction: ((_ start:Date, _ end:Date) -> Void)?
    var startDate:Date?
    
    // MARK: - Public Method
    
    public func setStart(date:Date) {
        startDate = date
    }
    
    // MARK: - Local Methods
    
    private func initialize() {
        if let target = self.topViewController as? TimeTicketDateViewController, let date = startDate {
            target.setStart(date: date)
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
*/
}
