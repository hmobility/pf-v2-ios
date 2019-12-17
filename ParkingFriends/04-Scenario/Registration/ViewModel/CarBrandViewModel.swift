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
    var modelItems: BehaviorRelay<[CarModelsElement]> { get }
    
    var selectedBrand: BehaviorRelay<CarBrandsElement> { get }
    var selectedModel: BehaviorRelay<CarModelsElement> { get }
    
    var proceed: BehaviorRelay<Bool> { get }
    
    func selectBrandItem(_ indexPath:IndexPath)
    func selectModelItem(_ indexPath:IndexPath)
    
    func loadMakerList()
 //   func loadModels(brand element:CarBrandsElement)
    func loadModels(brandIdx:Int)
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
    var modelItems: BehaviorRelay<[CarModelsElement]> = BehaviorRelay(value: [CarModelsElement]())
    
    var selectedBrand: BehaviorRelay<CarBrandsElement> = BehaviorRelay(value:CarBrandsElement())
    var selectedModel: BehaviorRelay<CarModelsElement> = BehaviorRelay(value:CarModelsElement())
    
    var proceed: BehaviorRelay<Bool> = BehaviorRelay(value:false)
    
    private let disposeBag = DisposeBag()
    private var localizer:LocalizerType
    
    private var registrationMdoel: RegistrationModel
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, registration:RegistrationModel) {
        self.localizer = localizer
        self.registrationMdoel = registration
        
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
        
        updateSelectedUserCarInfo()
    }
    
    // MARK: - Local Methods
    
    func updateSelectedUserCarInfo() {
        _ = Observable.zip(selectedBrand, selectedModel) { ($0, $1)}
            .asObservable()
            .subscribe(onNext: { (brand, model) in
                let isEmpty = brand.name.isEmpty && model.name.isEmpty
                
                if isEmpty == false {
                    self.selectedCarText.accept(brand.name + " " + model.name)
                    self.registrationMdoel.setCarModel(model)
                }
            
                self.proceed.accept(isEmpty ? false : true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    func selectBrandItem(_ indexPath:IndexPath) {
        guard brandItems.value.count > 0 else {
            return
        }
        
        let item = brandItems.value[indexPath.row]
        selectedBrand.accept(item)
    }
    
    func selectModelItem(_ indexPath:IndexPath) {
        guard brandItems.value.count > indexPath.row else {
            return
        }
              
        let item = modelItems.value[indexPath.row]
        selectedModel.accept(item)
    }
            
    func loadMakerList() {
        guard brandItems.value.count == 0 else {
            return
        }
        
        Common.cars_brands()
            .map { (results, response)in
                return (results?.elements ?? [])
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { elements in
                self.brandItems.accept(elements)
            }, onCompleted: {
                self.loadModels(brandIdx: 0)
            })
            .disposed(by: disposeBag)
    }
    
    func loadModels(brandIdx:Int) {
        print("[COUNT] ", brandItems.value.count)
        guard brandItems.value.count > brandIdx else {
            return
        }
        
        let element = brandItems.value[brandIdx]
        selectedBrand.accept(element)
        
        if let result = element.models {
            self.modelItems.accept(result)
        } else {
            Common.cars_brands_models(brandId: element.id)
                .map { (results, response)in
                    return (results?.elements ?? [])
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { models in
                    element.models = models
                    self.modelItems.accept(models)
                }, onError: { error in
                })
                .disposed(by: disposeBag)
        }

    }

    /*
    func loadModels(brand element:CarBrandsElement) {
        guard element.models == nil else {
            return
        }
        
        Common.cars_brands_models(brandId: element.id)
            .map { (results, response)in
                return (results?.elements ?? [])
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { models in
                element.models = models
                self.modelItems.accept(models)
            }, onError: { error in
            })
            .disposed(by: disposeBag)
    }
 */
}

