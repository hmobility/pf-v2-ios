//
//  ParkingStatusNavigationControll.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/20.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkingStatusNavigationController: UINavigationController {

    private var orderElement: OrderElement?
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement?) {
        self.orderElement = element
    }
    
    // MARK: - Local Methods
    
    private func initialize() {
        if let target = self.topViewController as? ParkingStatusViewController, let element = orderElement {
            target.setOrderElement(with: element)
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
