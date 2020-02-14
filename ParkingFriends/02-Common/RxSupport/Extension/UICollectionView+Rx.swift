//
//  UICollectionView+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/11.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

extension Reactive where Base: UICollectionView {
    var indexPathsForVisibleItems: Observable<[IndexPath]> {
        return Observable.of(base.rx.willDisplayCell, base.rx.didEndDisplayingCell)
            .merge()
            .map {_ in
                return self.base.indexPathsForVisibleItems
            }
            .filter { $0.count > 0 }
            .distinctUntilChanged()
    }
}

