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
    
    var priceUnitText: Driver<String> { get }
    var priceStartText: BehaviorRelay<String> { get }
    var priceEndText: BehaviorRelay<String> { get }
    var pricePerHourText: Driver<String> { get }
    var priceMinimumText: Driver<String> { get }
    var priceMaximumText: Driver<String> { get }
    var priceGuideText: Driver<String> { get }
    var selectedMinimumPrice: BehaviorRelay<Int> { get }
    var selectedMaximumPrice: BehaviorRelay<Int> { get }
    
    var sortTypeText: Driver<String> { get }
    var selectedSortType: BehaviorRelay<SortType> { get }
    var sortSegmentedItems: [(type:SortType, title:String)]  { get }
    
    var operationTypeText: Driver<String> { get }
    var operationSegmentedItems: [(type:ParkingLotType, title:String)] { get }
    var selectedOperationType: BehaviorRelay<ParkingLotType> { get }
    
    var areaTypeText: Driver<String> { get }

    var areaInOutSegmentedItems: [(type:InOutDoorType, title:String)] { get }
    var selectedInOutType: BehaviorRelay<InOutDoorType> { get }
    
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
    
    func setItemCCTV(_ flag:Bool)
    func setItemIotSensor(_ flag:Bool)
    func setItemMechanical(_ flag:Bool)
    func setItemFullTime(_ flag:Bool)
}

class SearchOptionViewModel: NSObject, SearchOptionViewModelType {
    var viewTitleText: Driver<String>
    
    var priceUnitText: Driver<String>
    var priceStartText: BehaviorRelay<String>
    var priceEndText: BehaviorRelay<String>
    var pricePerHourText: Driver<String>
    var priceMinimumText: Driver<String>
    var priceMaximumText: Driver<String>
    var priceGuideText: Driver<String>
    var selectedMinimumPrice: BehaviorRelay<Int>
    var selectedMaximumPrice: BehaviorRelay<Int>
    
    var sortTypeText: Driver<String>
    var selectedSortType: BehaviorRelay<SortType>
    var sortSegmentedItems: [(type:SortType, title:String)]
    
    var operationTypeText: Driver<String>
    var operationSegmentedItems: [(type:ParkingLotType, title:String)]
    var selectedOperationType: BehaviorRelay<ParkingLotType>

    var areaTypeText: Driver<String>
    
    var areaInOutSegmentedItems: [(type:InOutDoorType, title:String)]
    var selectedInOutType: BehaviorRelay<InOutDoorType>
    
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
        
        priceUnitText = localizer.localized("txt_money_unit")
        pricePerHourText = localizer.localized("ttl_price_per_unit")
        priceMinimumText = localizer.localized("txt_price_min")
        priceMaximumText = localizer.localized("txt_price_max")
        priceGuideText = localizer.localized("txt_price_guide")
        
        sortTypeText = localizer.localized("ttl_order_sorting")
        sortSegmentedItems = [(.price, localizer.localized("itm_order_price")), (.distance, localizer.localized("itm_order_distance"))]
        
        operationTypeText = localizer.localized("ttl_parkinglot_type")
        operationSegmentedItems = [(.none, localizer.localized("itm_parkinglot_none")), (.public_lot, localizer.localized("itm_parkinglot_public")), (.private_lot, localizer.localized("itm_parkinglot_private"))]
        
        areaTypeText = localizer.localized("ttl_area_type")
        areaInOutSegmentedItems = [(.none, localizer.localized("itm_area_none")), (.outdoor, localizer.localized("itm_area_outdoor")), (.indoor, localizer.localized("itm_area_indoor"))]
 
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
        selectedOperationType = BehaviorRelay(value:userData.filter.lotType)
        selectedInOutType = BehaviorRelay(value:userData.filter.inOutType)
        isItemCCTV = BehaviorRelay(value:userData.filter.isCCTV)
        isItemIotSensor = BehaviorRelay(value:userData.filter.isIotSensor)
        isItemMechanical =  BehaviorRelay(value:userData.filter.isNoMechanical)
        isItemFullTime =  BehaviorRelay(value:userData.filter.isAllDay)
        
        let start = (userData.filter.from > 0) ? userData.filter.from.withComma : localizer.localized("txt_free")
   
        priceStartText = BehaviorRelay(value: start)
        priceEndText = BehaviorRelay(value: userData.filter.to.withComma)
        
        super.init()
        initialize()
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        //setupBidning()
    }
    
    // MARK: - Local Methods
    
    func setMinimumPrice(_ price:Int) {
        let value:String = (price == 0) ? localizer.localized("txt_free") : price.withComma
        
        selectedMinimumPrice.accept(price)
        priceStartText.accept(value)
    }
    
    func setMaximumPrice(_ price:Int) {
        selectedMaximumPrice.accept(price)
        priceEndText.accept(price.withComma)
    }
    
    // MARK: - Public Methods
    func setItemCCTV(_ flag:Bool) {
        self.isItemIotSensor.accept(flag)
    }
    
    func setItemIotSensor(_ flag:Bool) {
        self.isItemIotSensor.accept(flag)
    }
    
    func setItemMechanical(_ flag:Bool) {
        self.isItemMechanical.accept(flag)
    }
    
    func setItemFullTime(_ flag:Bool) {
        self.isItemFullTime.accept(flag)
    }
    
    func setPrice(start:Int, end:Int) {
        
    }
    
    func getStoredValue() -> FilterOption? {
        return userData.filter
    }
    
    func reset() {
        setMinimumPrice(defaultFilterOption.from)
        setMaximumPrice(defaultFilterOption.to)
  
        selectedSortType.accept(defaultFilterOption.sortType)
        selectedOperationType.accept(defaultFilterOption.lotType)
        selectedInOutType.accept(defaultFilterOption.inOutType)
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
        userData.filter.lotType = selectedOperationType.value
        userData.filter.inOutType = selectedInOutType.value
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
        let max = Int(maxValue)
        let min = Int(minValue)
        
        if selectedMaximumPrice.value != max {
            setMaximumPrice(max)
        }
        
        if selectedMinimumPrice.value != min {
            setMinimumPrice(min)
        }
    }
}
