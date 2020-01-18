//
//  UITableViewCell+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

extension UITableViewCell {
    var tableView:UITableView? {
        return superview as? UITableView
    }

    var indexPath:IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
