//
//  UICollectionViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/15.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    var collectionView:UICollectionView? {
        return superview as? UICollectionView
    }
    
    var indexPath:IndexPath? {
        return collectionView?.indexPath(for: self)
    }
}
