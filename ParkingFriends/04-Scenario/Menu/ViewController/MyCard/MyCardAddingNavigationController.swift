//
//  MyCardAddingNavigationController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/24.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class MyCardAddingNavigationController: UINavigationController {
    
    var dismissAction: ((_ flag:Bool) -> Void)?
    
    // MARK: - Local Methods
    
    private func initialize() {
        if let target = self.topViewController as? MyCardAddingViewController {
            target.dismissAction = { flag in
                if let action = self.dismissAction {
                    action(flag)
                }
            }
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
