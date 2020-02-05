//
//  BetterSegmentedControl+Rx.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import Foundation
import BetterSegmentedControl

extension Reactive where Base: BetterSegmentedControl {
    public var selected: ControlProperty<Int> {
        return base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { segmentedControl -> Int in
                return segmentedControl.index
        },  setter: { segmentedControl, value in
            segmentedControl.setIndex(value)
        })
    }
}
