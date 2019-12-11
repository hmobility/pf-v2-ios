//
//  SearchOptionViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import RangeSeekSlider

protocol SearchOptionViewModelType {
    var viewTitleText: Driver<String> { get }
    var pricePerHourText: Driver<String> { get }
    var priceRangeText: Driver<String> { get }
    var priceMinimumText: Driver<String> { get }
    var priceMaximumText: Driver<String> { get }
    var priceGuideText: Driver<String> { get }
    var selectedMinimumPrice: BehaviorRelay<Int> { get }
    var selectedMaximumPrice: BehaviorRelay<Int> { get }
    
    var sortTypeText: Driver<String> { get }
    var sortItemLowPrice: Driver<String> { get }
    var sortItemNearby: Driver<String> { get }
    var selectedSortType: BehaviorRelay<FilterSortType> { get }
    
    var parkingLotTypeText: Driver<String> { get }
    var parkingLotItemNone: Driver<String> { get }
    var parkingLotItemPublic: Driver<String> { get }
    var parkingLotItemPrivate: Driver<String> { get }
    var selectedParkingLotType: BehaviorRelay<FilterOperationType> { get }
    
    var areaTypeText: Driver<String> { get }
    var areaItemNone: Driver<String> { get }
    var areaItemOutdoor: Driver<String> { get }
    var areaItemIndoor: Driver<String> { get }
    var selectedAreaType: BehaviorRelay<FilterAreaType> { get }
    
    var optionTypeText: Driver<String> { get }
    var optionItemCCTV: Driver<String> { get }
    var optionItemIotSensor: Driver<String> { get }
    var optionItemMechanical: Driver<String> { get }
    var optionItemFullTime: Driver<String> { get }
    
    var isItemCCTV: BehaviorRelay<Bool> { get }
    var isItemIotSensor: BehaviorRelay<Bool> { get }
    var isItemMechanical: BehaviorRelay<Bool> { get }
    var isItemFullTime: BehaviorRelay<Bool> { get }
    
    var resetText: Driver<String> { get }
    var saveText: Driver<String> { get }
    
    func save()
    func reset()
}

class SearchOptionViewModel: NSObject, SearchOptionViewModelType {
    var viewTitleText: Driver<String>
    
    var pricePerHourText: Driver<String>
    var priceRangeText: Driver<String>
    var priceMinimumText: Driver<String>
    var priceMaximumText: Driver<String>
    var priceGuideText: Driver<String>
    var selectedMinimumPrice: BehaviorRelay<Int>
    var selectedMaximumPrice: BehaviorRelay<Int>
    
    var sortTypeText: Driver<String>
    var sortItemLowPrice: Driver<String>
    var sortItemNearby: Driver<String>
    var selectedSortType: BehaviorRelay<FilterSortType>
    
    var parkingLotTypeText: Driver<String>
    var parkingLotItemNone: Driver<String>
    var parkingLotItemPublic: Driver<String>
    var parkingLotItemPrivate: Driver<String>
    var selectedParkingLotType: BehaviorRelay<FilterOperationType>
    
    var areaTypeText: Driver<String>
    var areaItemNone: Driver<String>
    var areaItemOutdoor: Driver<String>
    var areaItemIndoor: Driver<String>
    var selectedAreaType: BehaviorRelay<FilterAreaType>
    
    var optionTypeText: Driver<String>
    var optionItemCCTV: Driver<String>
    var optionItemIotSensor: Driver<String>
    var optionItemMechanical: Driver<String>
    var optionItemFullTime: Driver<String>
    
    var isItemCCTV: BehaviorRelay<Bool>
    var isItemIotSensor: BehaviorRelay<Bool>
    var isItemMechanical: BehaviorRelay<Bool>
    var isItemFullTime: BehaviorRelay<Bool>
    
    var resetText: Driver<String>
    var saveText: Driver<String>
    
    private var localizer:LocalizerType
    private var userData:UserData
    
    init(localizer: LocalizerType = Localizer.shared, userData: UserData = UserData.shared) {
        self.localizer = localizer
        self.userData = userData
        
        viewTitleText = localizer.localized("ttl_search_option")
        pricePerHourText = localizer.localized("ttl_price_per_unit")
        priceRangeText = localizer.localized("txt_price_range")
        priceMinimumText = localizer.localized("txt_price_min")
        priceMaximumText = localizer.localized("txt_price_max")
        priceGuideText = localizer.localized("txt_price_guide")
        
        sortTypeText = localizer.localized("ttl_order_sorting")
        sortItemLowPrice = localizer.localized("itm_low_price")
        sortItemNearby = localizer.localized("itm_nearby")
        
        parkingLotTypeText = localizer.localized("ttl_parkinglot_type")
        parkingLotItemNone = localizer.localized("itm_parkinglot_none")
        parkingLotItemPublic = localizer.localized("itm_parkinglot_public")
        parkingLotItemPrivate = localizer.localized("itm_parkinglot_private")
        
        areaTypeText = localizer.localized("ttl_area_type")
        areaItemNone = localizer.localized("itm_area_none")
        areaItemOutdoor = localizer.localized("itm_area_outdoor")
        areaItemIndoor = localizer.localized("itm_area_indoor")
        
        optionTypeText = localizer.localized("ttl_extra_option")
        optionItemCCTV = localizer.localized("itm_option_cctv")
        optionItemIotSensor = localizer.localized("itm_option_iot_sensor")
        optionItemMechanical = localizer.localized("itm_option_mechanical")
        optionItemFullTime = localizer.localized("itm_option_full_time")
        
        resetText = localizer.localized("btn_to_reset")
        saveText = localizer.localized("btn_to_save")
        
        
        selectedMinimumPrice = BehaviorRelay(value:userData.filter.from)
        selectedMaximumPrice = BehaviorRelay(value:userData.filter.to)
        selectedSortType = BehaviorRelay(value:userData.filter.sortType)
        selectedParkingLotType = BehaviorRelay(value:userData.filter.operationType)
        selectedAreaType = BehaviorRelay(value:userData.filter.areaType)
        isItemCCTV = BehaviorRelay(value:userData.filter.isCCTV)
        isItemIotSensor = BehaviorRelay(value:userData.filter.isIotSensor)
        isItemMechanical =  BehaviorRelay(value:userData.filter.isNoMechanical)
        isItemFullTime =  BehaviorRelay(value:userData.filter.isAllDay)
        
        selectedMinimumPrice = BehaviorRelay(value:0)
        selectedMaximumPrice = BehaviorRelay(value:10000)
        selectedSortType = BehaviorRelay(value:.low_price)
        selectedParkingLotType = BehaviorRelay(value:.none)
        selectedAreaType = BehaviorRelay(value:.none)
        isItemCCTV = BehaviorRelay(value:false)
        isItemIotSensor = BehaviorRelay(value:false)
        isItemMechanical =  BehaviorRelay(value:false)
        isItemFullTime =  BehaviorRelay(value:false)
        
        super.init()
             
        initialize()
    }
    
    // MARK: - Local Methods
    
    private func initialize() {
        //setupBidning()
    }
    
    // MARK: - Public Methods
    
    func reset() {
        selectedMinimumPrice.accept(0)
        selectedMaximumPrice.accept(10000)
        selectedSortType.accept(.low_price)
        selectedParkingLotType.accept(.none)
        selectedAreaType.accept(.none)
        isItemCCTV.accept(false)
        isItemIotSensor.accept(false)
        isItemMechanical.accept(false)
        isItemFullTime.accept(false)
         
        self.save()
    }
    
    func save() {
        userData.filter.from = selectedMinimumPrice.value
        userData.filter.to = selectedMaximumPrice.value
        userData.filter.sortType = selectedSortType.value
        userData.filter.operationType = selectedParkingLotType.value
        userData.filter.areaType = selectedAreaType.value
        userData.filter.isCCTV = isItemCCTV.value
        userData.filter.isIotSensor = isItemIotSensor.value
        userData.filter.isNoMechanical = isItemMechanical.value
        userData.filter.isAllDay = isItemFullTime.value
            
        userData.save()
    }
}

extension SearchOptionViewModel: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if selectedMaximumPrice.value != Int(maxValue) {
            selectedMaximumPrice.accept(Int(maxValue))
        }
        
        if selectedMinimumPrice.value != Int(minValue) {
            selectedMinimumPrice.accept(Int(minValue))
        }
    }
}
