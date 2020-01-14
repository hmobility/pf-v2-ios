//
//  MonthlyTicketNavigationController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/12.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MonthlyTicketNavigationController: UINavigationController {
    var completeAction: ((_ start:Date, _ months:Int) -> Void)?
    var startDate:Date?
    
    // MARK: - Public Method
    
    public func setStart(date:Date) {
        startDate = date
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? MonthlyTicketDurationViewController {
            if let start = self.startDate {
                target.setStartDate(start)
            }
        }
    }
}
