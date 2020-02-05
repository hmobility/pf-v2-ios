//
//  UISearchBar.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

extension Reactive where Base: UISearchBar {
    public var placeholder: Binder<String?> {
        return Binder(self.base) { searchBar, text in
            searchBar.placeholder = text
        }
    }
}
