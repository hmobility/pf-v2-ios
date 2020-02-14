//
//  ParkinglotCardViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/24.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol ParkingCardViewModelType {
    var priceUnitText: Driver<String> { get }
    
    var elements:BehaviorRelay<[WithinElement]> { get }
    
    func setWithinElements(_ elements:[WithinElement]?)
    func getWithinElement(with itemIndex:Int) -> WithinElement?
    func getTags(_ element:WithinElement) -> [String]
}

class ParkingCardViewModel: ParkingCardViewModelType {
    var priceUnitText: Driver<String>
    
    var elements: BehaviorRelay<[WithinElement]> = BehaviorRelay(value: [])
    
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        self.priceUnitText = localizer.localized("txt_won")

        initialize()
    }
    
    func initialize() {
        setupBinding()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
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
    
    func setWithinElements(_ elements:[WithinElement]?){
        if let items = elements {
            self.elements.accept(items)
        } else {
            self.elements.accept([])
        }
    }
    
    func getWithinElement(with itemIndex:Int) -> WithinElement? {
        if itemIndex < self.elements.value.count {
            return self.elements.value[itemIndex]
        }
        
        return nil
    }
}
