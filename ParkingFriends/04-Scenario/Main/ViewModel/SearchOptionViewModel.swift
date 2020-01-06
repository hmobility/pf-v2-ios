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
    var selectedSortType: BehaviorRelay<SortType> { get }
    
    var operationTypeText: Driver<String> { get }
    var operationItemNone: Driver<String> { get }
    var operationItemPublic: Driver<String> { get }
    var operationItemPrivate: Driver<String> { get }
    var selectedOperationType: BehaviorRelay<ParkingLotType> { get }
    
    var areaTypeText: Driver<String> { get }
    var areaItemNone: Driver<String> { get }
    var areaItemOutdoor: Driver<String> { get }
    var areaItemIndoor: Driver<String> { get }
    var selectedAreaType: BehaviorRelay<InOutDoorType> { get }
    
    var optionTypeText: Driver<String> { get }
    var optionItemCCTV: Driver<String> { get }
    var optionItemIotSensor: Driver<String> { get }
    var optionItemNoMechanical: Driver<String> { get }
    var optionItemFullTime: Driver<String> { get }
    
    var isItemCCTV: BehaviorRelay<Bool> { get }
    var isItemIotSensor: BehaviorRelay<Bool> { get }
    var isItemMechanical: BehaviorRelay<Bool> { get }
    var isItemFullTime: BehaviorRelay<Bool> { get }
    
    var resetText: Driver<String> { get }
    var saveText: Driver<String> { get }
    
    func save()
    func reset()
    
    func getStoredValue() -> FilterOption?
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
    var selectedSortType: BehaviorRelay<SortType>
    
    var operationTypeText: Driver<String>
    var operationItemNone: Driver<String>
    var operationItemPublic: Driver<String>
    var operationItemPrivate: Driver<String>
    var selectedOperationType: BehaviorRelay<ParkingLotType>
    
    var areaTypeText: Driver<String>
    var areaItemNone: Driver<String>
    var areaItemOutdoor: Driver<String>
    var areaItemIndoor: Driver<String>
    var selectedAreaType: BehaviorRelay<InOutDoorType>
    
    var optionTypeText: Driver<String>
    var optionItemCCTV: Driver<String>
    var optionItemIotSensor: Driver<String>
    var optionItemNoMechanical: Driver<String>
    var optionItemFullTime: Driver<String>
    
    var isItemCCTV: BehaviorRelay<Bool>
    var isItemIotSensor: BehaviorRelay<Bool>
    var isItemMechanical: BehaviorRelay<Bool>
    var isItemFullTime: BehaviorRelay<Bool>
    
    var resetText: Driver<String>
    var saveText: Driver<String>
    
    private var localizer:LocalizerType
    private var userData:UserData
    
    private var defaultFilterOption:FilterOption = FilterOption()
    
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
        
        operationTypeText = localizer.localized("ttl_parkinglot_type")
        operationItemNone = localizer.localized("itm_parkinglot_none")
        operationItemPublic = localizer.localized("itm_parkinglot_public")
        operationItemPrivate = localizer.localized("itm_parkinglot_private")
        
        areaTypeText = localizer.localized("ttl_area_type")
        areaItemNone = localizer.localized("itm_area_none")
        areaItemOutdoor = localizer.localized("itm_area_outdoor")
        areaItemIndoor = localizer.localized("itm_area_indoor")
        
        optionTypeText = localizer.localized("ttl_extra_option")
        optionItemCCTV = localizer.localized("itm_option_cctv")
        optionItemIotSensor = localizer.localized("itm_option_iot_sensor")
        optionItemNoMechanical = localizer.localized("itm_option_mechanical")
        optionItemFullTime = localizer.localized("itm_option_full_time")
        
        resetText = localizer.localized("btn_to_reset")
        saveText = localizer.localized("btn_to_save")
        
        selectedMinimumPrice = BehaviorRelay(value:userData.filter.from)
        selectedMaximumPrice = BehaviorRelay(value:userData.filter.to)
        selectedSortType = BehaviorRelay(value:userData.filter.sortType)
        selectedOperationType = BehaviorRelay(value:userData.filter.operationType)
        selectedAreaType = BehaviorRelay(value:userData.filter.areaType)
        isItemCCTV = BehaviorRelay(value:userData.filter.isCCTV)
        isItemIotSensor = BehaviorRelay(value:userData.filter.isIotSensor)
        isItemMechanical =  BehaviorRelay(value:userData.filter.isNoMechanical)
        isItemFullTime =  BehaviorRelay(value:userData.filter.isAllDay)

        super.init()
        initialize()
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        //setupBidning()
    }
    
    // MARK: - Local Methods
    
    func updatePriceRange(start:String, end:String) {
        
    }
    
    // MARK: - Public Methods
    
    func getStoredValue() -> FilterOption? {
        return userData.filter
    }
    
    func reset() {
        selectedMinimumPrice.accept(defaultFilterOption.from)
        selectedMaximumPrice.accept(defaultFilterOption.to)
        selectedSortType.accept(defaultFilterOption.sortType)
        selectedOperationType.accept(defaultFilterOption.operationType)
        selectedAreaType.accept(defaultFilterOption.areaType)
        isItemCCTV.accept(defaultFilterOption.isCCTV)
        isItemIotSensor.accept(defaultFilterOption.isIotSensor)
        isItemMechanical.accept(defaultFilterOption.isNoMechanical)
        isItemFullTime.accept(defaultFilterOption.isAllDay)
         
       // self.save()
    }
    
    func save() {
        userData.filter.from = selectedMinimumPrice.value
        userData.filter.to = selectedMaximumPrice.value
        userData.filter.sortType = selectedSortType.value
        userData.filter.operationType = selectedOperationType.value
        userData.filter.areaType = selectedAreaType.value
        userData.filter.isCCTV = isItemCCTV.value
        userData.filter.isIotSensor = isItemIotSensor.value
        userData.filter.isNoMechanical = isItemMechanical.value
        userData.filter.isAllDay = isItemFullTime.value
            
        userData.save()
    }
}

// MARK: - RangeSeekSliderDelegate

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
