//
//  SplashViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

extension SplashViewController : AnalyticsType {
    var screenName: String {
        return "Splash Screen"
    }
}

class SplashViewController: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreen()
        navigateEntry()
    }
    
    // MARK: - Navigation
    
    private func navigateEntry() {
        let entry = Storyboard.entry.instantiateInitialViewController() as! UINavigationController
        self.modal(entry, animated: false)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
