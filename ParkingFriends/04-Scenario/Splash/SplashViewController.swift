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
    
    private func moveTutorial() {
        let tutorial = Storyboard.tutorial.instantiateInitialViewController() as! UINavigationController
        self.modal(tutorial, animated: false)
    }
    
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
        moveTutorial()
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
