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
    var carTypeInputPlaceholder: Driver<String> { get }
    var carNumberInputTitle: Driver<String> { get }
    var carNumberInputPlaceholder: Driver<String> { get }
    var carColorInputTitle: Driver<String> { get }
    var carColorInputPlaceholder: Driver<String> { get }
    var selectedCarFieldText: Driver<String> { get }
    var selectedCarText: BehaviorRelay<String> { get }
}

class CarBrandViewModel: CarBrandViewModelType {
    var viewTitleText: Driver<String>
    var closeText: Driver<String>
    var nextText: Driver<String>
    var carTypeInputTitle: Driver<String>
    var carTypeInputPlaceholder: Driver<String>
    var carNumberInputTitle: Driver<String>
    var carNumberInputPlaceholder: Driver<String>
    var carColorInputTitle: Driver<String>
    var carColorInputPlaceholder: Driver<String>
    var selectedCarFieldText: Driver<String>
    var selectedCarText: BehaviorRelay<String> = BehaviorRelay(value:"")
    
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
    
    func loadBrand() {
        Common.cars_brands()
            .asObservable()
            .subscribe(onNext:
                { (data, respnose) in
                print("[Brand]", data)
            }, onError: { error in
            
            })
    }
    
    func loadModels(brandId:String) {
        Common.cars_brands_models(brandId: brandId)
            .asObservable()
            .subscribe(onNext: { (data, respnose) in
                print("[Model]", data)
            }, onError: { error in
            
            })
    }
}

