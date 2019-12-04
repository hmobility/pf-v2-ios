//
//  CardPaymentModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

public protocol CardPaymentModelType {
    func message(_ type:CheckType) -> String
}

final class CardPaymentModel: CardPaymentModelType {
    func message(_ type: CheckType) -> String {
        return ""
    }
    
}
