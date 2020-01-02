//
//  BottomFloatingPanelLayout.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import FloatingPanel

class BottomFloatingLayout: FloatingPanelLayout {
    private var bottomInset:CGFloat
    
    init(bottomInset:CGFloat) {
        self.bottomInset = bottomInset
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 0.0 // A top inset from safe area
         case .tip:
            return bottomInset // A bottom inset from the safe area
        default:
            return nil // Or `case .hidden: return nil`
        }
    }
}
