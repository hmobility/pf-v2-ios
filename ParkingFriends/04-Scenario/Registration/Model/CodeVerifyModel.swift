//
//  CodeVerifyModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/26.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

public protocol CodeVerifyModelType {
}

final class CodeVerifyModel {
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
}
