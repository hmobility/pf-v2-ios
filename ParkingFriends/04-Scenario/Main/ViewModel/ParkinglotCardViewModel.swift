//
//  ParkinglotCardViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/24.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol ParkinglotCardViewModelType {
    var elements:BehaviorRelay<[WithinElement]> { get }
    
    var priceUnitText: Driver<String> { get }
    
    func setWithinElements(_ elements:[WithinElement])
    func getTags(_ element:WithinElement) -> [String]
}

class ParkinglotCardViewModel: ParkinglotCardViewModelType {
    
    var priceUnitText: Driver<String> 
    
    var elements:BehaviorRelay<[WithinElement]> = BehaviorRelay(value:[])
    
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        priceUnitText = localizer.localized("txt_won")
    
        initialize()
    }
    
    func initialize() {
        setupBinding()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
    }
    
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
    // MARK: - Public Methods
    
    func setWithinElements(_ elements:[WithinElement]){
        self.elements.accept(elements)
    }
}
