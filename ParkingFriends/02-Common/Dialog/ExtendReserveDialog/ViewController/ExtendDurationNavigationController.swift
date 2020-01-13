//
//  ExtendDurationNavigationController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/13.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ExtendDurationNavigationController: UINavigationController {
    var completionAction: ((_ start:Date, _ months:Int) -> Void)?
    var startDate:Date?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
