//
//  GuideFinishedViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension GuideFinishedViewController : AnalyticsType {
    var screenName: String {
        return "Guide Finished Screen"
    }
}

class GuideFinishedViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var beginButton: UIButton!

    @IBAction func beginButtonAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         trackScreen()
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
