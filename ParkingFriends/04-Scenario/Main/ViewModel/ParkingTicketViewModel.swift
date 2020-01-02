//
//  ParkingTicketViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/28.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingTicketViewModelType {
    var elements:BehaviorRelay<[WithinElement]> { get }
    
    func setWithinElements(_ elements:[WithinElement])
    func getTags(_ element:WithinElement) -> [String]
}

class ParkingTicketViewModel: ParkingTicketViewModelType {
    var elements: BehaviorRelay<[WithinElement]> = BehaviorRelay(value: [])
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    // MARK: - Public Methods
    
    func getTags(_ element:WithinElement) -> [String] {
        var tags:[String] = []
        
        if element.cctvFlag {
            tags.append(localizer.localized("itm_cctv"))
        }
        
        if element.outsideFlag {
            tags.append(localizer.localized("itm_cctv"))
        }
        
        if element.chargerFlag {
            tags.append(localizer.localized("itm_evc"))
        }
        
        if element.iotSensorFlag {
            tags.append(localizer.localized("itm_iot"))
        }
        
        tags.append((element.outsideFlag) ? localizer.localized("itm_outdoor") : localizer.localized("itm_indoor"))
        
        return tags
    }
    
    func setWithinElements(_ elements:[WithinElement]){
        self.elements.accept(elements)
    }
}
