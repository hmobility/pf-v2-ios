//
//  RegiCarViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit

protocol RegiCarViewModelType {
    var viewTitle: Driver<String> { get }
    
    var carBrandInputTitle: Driver<String> { get }
    var carBrandPlaceholder: Driver<String> { get }
    var carBrandText: BehaviorRelay<String> { get }
    var carBrandMessageText: BehaviorRelay<String> { get }
    
    var carNumberInputTitle: Driver<String> { get }
    var carNumberPlaceholder: Driver<String> { get }
    var carNumberText: BehaviorRelay<String> { get }
    var carNumberMessageText: BehaviorRelay<String> { get }
    
    var carColorInputTitle: Driver<String> { get }
    var carColorPlaceholder: Driver<String> { get }
    var carColorText: BehaviorRelay<String> { get }
    var carColorMessageText: BehaviorRelay<String> { get }
    
    var carInfo:CarNumberModelType { get }
    
    func setCarColor(_ color:ColorType)
    func validateCarNumber() -> Bool
}

class RegiCarViewModel: RegiCarViewModelType {
    var viewTitle: Driver<String>
    
    var carBrandInputTitle: Driver<String>
    var carBrandPlaceholder: Driver<String>
    var carBrandText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var carBrandMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var carNumberInputTitle: Driver<String>
    var carNumberPlaceholder: Driver<String>
    var carNumberText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var carNumberMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var carColorInputTitle: Driver<String>
    var carColorPlaceholder: Driver<String>
    var carColorText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var carColorMessageText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    var carInfo:CarNumberModelType
    
    private var selectedColor:ColorType = .white
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, carInfo:CarNumberModelType) {
        self.localizer = localizer
        self.carInfo = carInfo
        
        viewTitle = self.localizer.localized("ttl_car_info_registration")
        carBrandPlaceholder = localizer.localized("ph_car_type")
        carBrandInputTitle = localizer.localized("ttl_car_type")
        carNumberPlaceholder = localizer.localized("ph_car_number")
        carNumberInputTitle = localizer.localized("ttl_car_number")
        carColorPlaceholder = localizer.localized("ph_car_color")
        carColorInputTitle = localizer.localized("ttl_car_color")
        
        carInfo.number.asDriver()
            .drive(onNext: { text in
                print("[MODEL] ", text , " -> ", self.validateCarNumber())
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    func setCarColor(_ color:ColorType) {
        selectedColor = color
        let key = color.rawValue
        let colorString = localizer.localized(key) as String
        carColorText.accept(colorString)
    }
    
    func validateCarNumber() -> Bool{
        return carInfo.validate()
    }
    
    func registerCarInfo() {
        Member.cars(modelId: 0, carNo: "", color: "", defaultFlag: true)
            .asObservable()
            .subscribe(onNext: { code in
        
            })
            .disposed(by: disposeBag)
    }
}
