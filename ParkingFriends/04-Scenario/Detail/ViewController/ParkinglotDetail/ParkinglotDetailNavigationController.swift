//
//  ParkinglotDetailNavigationController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailNavigationController: UINavigationController {
    var within:WithinElement?
    var favorite:FavoriteElement?
    
    // MARK: - Public Method
    
    public func setWithinElement(_ element:WithinElement) {
        within = element
    }
    
    public func setFavoriteElement(_ element:FavoriteElement?) {
        favorite = element
    }
    
    // MARK: - Local Methods
    
    private func initialize() {
        if let target = self.topViewController as? ParkinglotDetailViewController, let element = within {
            target.setWithinElement(element)
        }
        
        if let target = self.topViewController as? ParkinglotDetailViewController, let element = favorite {
            target.setFavoriteElement(element)
        }
    }
    
    // MARK: - Life Cyccle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
