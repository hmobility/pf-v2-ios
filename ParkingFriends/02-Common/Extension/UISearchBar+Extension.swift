//
//  UISearchBar+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/08.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    var searchField : UITextField {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            return value(forKey: "searchField") as! UITextField
        }
    }
    /*
    @available(iOS, obsoleted:13.0)
    var searchTextField: UITextField {
        return self.value(forKey: "searchField") as! UITextField
    }
    */
}
