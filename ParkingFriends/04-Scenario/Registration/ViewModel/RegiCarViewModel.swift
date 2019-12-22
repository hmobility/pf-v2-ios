//
//  RegiCarViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import UIKit


enum SectionType {
    case car_number, car_model, car_color
}

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
    
    var proceed: BehaviorRelay<Bool> { get }
    
    var carInfo:CarNumberModelType { get }
    
    func setCarColor(_ color:ColorType)
    func updateCarModel()
    
    func validateCredentials() -> Bool
    func registerCarInfo(finished:@escaping(Bool) -> Void)
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
    
    var proceed: BehaviorRelay<Bool> = BehaviorRelay(value:false)
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    var carInfo:CarNumberModelType
    
    private var registrationMdoel: RegistrationModel
    
    private var selectedColor:ColorType = .white
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, carInfo:CarNumberModelType, registration:RegistrationModel) {
        self.localizer = localizer
        self.carInfo = carInfo
        self.registrationMdoel = registration
        
        viewTitle = self.localizer.localized("ttl_car_info_registration")
        carBrandPlaceholder = localizer.localized("ph_car_type")
        carBrandInputTitle = localizer.localized("ttl_car_type")
        carNumberPlaceholder = localizer.localized("ph_car_number")
        carNumberInputTitle = localizer.localized("ttl_car_number")
        carColorPlaceholder = localizer.localized("ph_car_color")
        carColorInputTitle = localizer.localized("ttl_car_color")
    }
    
    // MARK: - Local Methods
    
    func updateStatus(_ section:SectionType, message:String) {
        switch section {
        case .car_number:
            carNumberMessageText.accept(message)
        case .car_model:
            let message = localizer.localized("msg_car_model_empty") as String
            carBrandMessageText.accept(message)
        case .car_color:
            let message = localizer.localized("msg_car_color_empty") as String
            carColorMessageText.accept(message)
        }
    }
        
    // MARK: - Public Methods
    
    func setCarColor(_ color:ColorType) {
        selectedColor = color
        let key = color.rawValue
        let colorString = localizer.localized(key) as String
        carColorText.accept(colorString)
        self.registrationMdoel.setCarColor(colorString)
        
        _ = validateCredentials()
    }
    
    func validateCarNumber() -> Bool {
        let result = carInfo.validate()
        let message = carInfo.message(result)
        
        updateStatus(.car_number, message: message)
        
        if result == .valid {
            registrationMdoel.setCarNumber(carInfo.number.value )
        }
        
        return result == .valid ? true : false
    }
    
    func updateCarModel() {
        if let model = registrationMdoel.carModel, let brand = registrationMdoel.carBrand {
            carBrandText.accept(brand.name + " " + model.name)
        }
        
        _ = validateCredentials()
    }
    
    func validateCredentials() -> Bool {
        let result = validateCarNumber() && !carBrandText.value.isEmpty && !carColorText.value.isEmpty
        proceed.accept(result)
        
        return result
    }
    
    // MARK: - Network
    
    func registerCarInfo(finished:@escaping(Bool) -> Void) {
        if let model = registrationMdoel.carModel, let number = registrationMdoel.carNumber, let color = registrationMdoel.carColor {
            Member.cars(modelId: model.id, carNo: number, color: color, defaultFlag: true)
                .asObservable()
                .subscribe(onNext: { code in
                    finished(code == .success ? true : false)
                })
                .disposed(by: disposeBag)
        }
    }
}
