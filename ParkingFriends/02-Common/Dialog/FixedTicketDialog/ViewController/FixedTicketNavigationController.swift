//
//  FixedTicketNavigationController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class FixedTicketNavigationController: UINavigationController {
    
    var completeAction: ((_ start:Date, _ hours:Int) -> Void)?
    var startDate:Date?
    
    // MARK: - Public Method
    
    public func setStart(date:Date) {
        startDate = date
    }
    
    // MARK: - Local Method
    
    private func initialize() {
        if let target = self.topViewController as? FixedTicketDurationViewController, let date = startDate {
            target.setStartDate(date)
        }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
*/
}
