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
}

class CarBrandViewModel: CarBrandViewModelType {
    var viewTitleText: Driver<String>
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_car_info_registration")
        
    }
    
    func loadBrand() {
        Common.cars_brands()
            .asObservable()
            .subscribe(onNext: { (data, respnose) in
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

