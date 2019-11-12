//
//  Reactive+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/10.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

extension Reactive where Base: UITextField {
    public var placeholder: Binder<String?> {
        return Binder(self.base) { textfield, text in
            textfield.placeholder = text
        }
    }
}
