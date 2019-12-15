//
//  CarBrandViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/06.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

protocol CarBrandViewModelType {
    var viewTitleText: Driver<String> { get }
    var closeText: Driver<String> { get }
    var nextText: Driver<String> { get }
    var carTypeInputTitle: Driver<String> { get }
    var carTypeInputText: BehaviorRelay<String> { get }
    var carTypeInputPlaceholder: Driver<String> { get }
    var carNumberInputTitle: Driver<String> { get }
    var carNumberText: BehaviorRelay<String> { get }
    var carNumberInputPlaceholder: Driver<String> { get }
    var carColorInputTitle: Driver<String> { get }
    var carColorInputText: BehaviorRelay<String> { get }
    var carColorInputPlaceholder: Driver<String> { get }
    var selectedCarFieldText: Driver<String> { get }
    var selectedCarText: BehaviorRelay<String> { get }
    
    var brandItems: BehaviorRelay<[CarBrandsElement]> { get }
    var modelItems: BehaviorRelay<[CarModelElement]> { get }
    
    var selectedBrand: BehaviorRelay<CarBrandsElement> { get }
    var selectedModel: BehaviorRelay<CarModelElement> { get }
    
    var proceed: BehaviorRelay<Bool> { get }
    
    func loadMakerList()
    func loadModels(brandId:Int)
}

class CarBrandViewModel: CarBrandViewModelType {
    var viewTitleText: Driver<String>
    var closeText: Driver<String>
    var nextText: Driver<String>
    
    var carTypeInputTitle: Driver<String>
    var carTypeInputText: BehaviorRelay<String> = BehaviorRelay(value:"")
    var carTypeInputPlaceholder: Driver<String>
    
    var carNumberInputTitle: Driver<String>
    var carNumberText: BehaviorRelay<String> = BehaviorRelay(value:"")
    var carNumberInputPlaceholder: Driver<String>
    
    var carColorInputTitle: Driver<String>
    var carColorInputText: BehaviorRelay<String> = BehaviorRelay(value:"")
    var carColorInputPlaceholder: Driver<String>
    
    var selectedCarFieldText: Driver<String>
    var selectedCarText: BehaviorRelay<String> = BehaviorRelay(value:"")
    
    var brandItems: BehaviorRelay<[CarBrandsElement]> = BehaviorRelay(value: [CarBrandsElement]())
    var modelItems: BehaviorRelay<[CarModelElement]> = BehaviorRelay(value: [CarModelElement]())
    
    var selectedBrand: BehaviorRelay<CarBrandsElement> = BehaviorRelay(value:CarBrandsElement())
     var selectedModel: BehaviorRelay<CarModelElement> = BehaviorRelay(value:CarModelElement())
    
    var proceed: BehaviorRelay<Bool> = BehaviorRelay(value:false)
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_car_info_registration")
        closeText = localizer.localized("btn_close")
        nextText = localizer.localized("btn_to_next")
        carTypeInputTitle = localizer.localized("ttl_car_type")
        carTypeInputPlaceholder = localizer.localized("ph_car_type")
        carNumberInputTitle = localizer.localized("ttl_car_number")
        carNumberInputPlaceholder = localizer.localized("ph_car_number")
        carColorInputTitle = localizer.localized("ttl_car_color")
        carColorInputPlaceholder = localizer.localized("ph_car_color")
        selectedCarFieldText = localizer.localized("ttl_selected_car")
    }
    
    // MARK: - Public Methods
    
    func validate() -> Bool {
        return false
    }
            
    func loadMakerList() {
        guard brandItems.value.count == 0 else {
            return
        }
        
        Common.cars_brands()
            .map { (results, response)in
                return (results?.elements ?? [])
            }
            .do(onNext: { results in
                if results.count > 0 {
                    let brandId = results[0].id
                    self.loadModels(brandId: brandId)
                }
            })
            .observeOn(MainScheduler.instance)
            .bind(to: brandItems)
            .disposed(by: disposeBag)
    }
    
    func loadModels(brandId:Int) {
        Common.cars_brands_models(brandId: brandId)
            .map { (results, response)in
                return (results?.elements ?? [])
            }
            .observeOn(MainScheduler.instance)
            .bind(to: modelItems)
            .disposed(by: disposeBag)
    }
}

