//
//  ParkinglotDetailSymbolViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/27.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailSymbolViewModelType {
    var markSymbolList: BehaviorRelay<[SymbolType]> { get }
      
    func setParkingSymbols(_ elements:FlagElement)
}

class ParkinglotDetailSymbolViewModel: ParkinglotDetailSymbolViewModelType {
    var markSymbolList: BehaviorRelay<[SymbolType]> = BehaviorRelay(value: [])
    
    private var localizer:LocalizerType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    // MARK: - Public Methods
    
    func setParkingSymbols(_ elements:FlagElement) {
        let symbols = getParkinglotSymbols(elements)
        
        if symbols.count > 0 {
            markSymbolList.accept(symbols)
        }
    }
    
    // MARK: - Local Methods
    
    func updateParkingSymbols(_ flagElements:FlagElement) {
        let symbols = getParkinglotSymbols(flagElements)
        
        markSymbolList.accept(symbols)
    }

    func getParkinglotSymbols(_ flagElements:FlagElement) -> [SymbolType] {
        var symbols:[(title:String, image:UIImage)] = []
        
        if flagElements.bleGateFlag {
            symbols.append((self.localizer.localized("itm_symbol_ble_gate"), UIImage(named:"icParkingLotInfoType21Outdoor")!))
        }
        
        if flagElements.cctvFlag {
            symbols.append((self.localizer.localized("itm_symbol_cctv"), UIImage(named:"icParkingLotInfoType3Cctv")!))
        }
        
        if flagElements.chargerFlag {
            symbols.append((self.localizer.localized("itm_symbol_charger"), UIImage(named:"icParkingLotInfoType3Electric")!))
        }
        
        if flagElements.iotSensorFlag {
            symbols.append((self.localizer.localized("itm_symbol_iot_sensor"), UIImage(named:"icParkingLotInfoType3Sensor")!))
        }
        
        if flagElements.outsideFlag {
            symbols.append((self.localizer.localized("itm_symbol_outdoor"), UIImage(named:"icParkingLotInfoType21Outdoor")!))
        } else {
            symbols.append((self.localizer.localized("itm_symbol_indoor"), UIImage(named:"icParkingLotInfoType22Indoor")!))
        }
        
        if flagElements.partnerFlag {
            symbols.append((self.localizer.localized("itm_symbol_partner"), UIImage(named:"icParkingLotInfoType14AffiliateAj")!))
        }
        
        return symbols
    }
}
