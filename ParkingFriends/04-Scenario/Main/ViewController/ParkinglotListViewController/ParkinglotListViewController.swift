//
//  ParkinglotListViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension ParkinglotListViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Parkinglot List"
    }
}

class ParkinglotListViewController: UIViewController {
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var fixedButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    
    @IBOutlet weak var sortButton: UIButton!
    
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
