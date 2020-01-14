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
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? FixedTicketDurationViewController {
            if let start = self.startDate {
                target.setStartDate(start)
            }
        }
    }

}
