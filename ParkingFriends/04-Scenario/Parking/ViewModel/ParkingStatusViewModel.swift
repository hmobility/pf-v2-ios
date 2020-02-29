//
//  ParkingStatusViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


protocol ParkingStatusViewModelType {
    var viewTitleText: Driver<String> { get }
    var parkingStatusDescText: Driver<String> { get }
    var directionGuideText: Driver<String> { get }
    var departueText: Driver<String> { get }
    var reserveExtensionText: Driver<String> { get }
    
    func getGuideText() -> Observable<String>
    
    func setOrderElement(_ element:OrderElement)
    func getUsagesItem() -> Observable<Usages>
    func getCameraList() -> Observable<[CamElement]>
}

class ParkingStatusViewModel: ParkingStatusViewModelType {
    var viewTitleText: Driver<String>
    var parkingStatusDescText: Driver<String>
    var directionGuideText: Driver<String>
    var departueText: Driver<String>
    var reserveExtensionText: Driver<String>
    
    var confirmText: Driver<String>
    var usageItem: BehaviorRelay<Usages?> = BehaviorRelay(value: nil)
    var orderElement: OrderElement?
    
    var camLogin: BehaviorRelay<CamLogin?> = BehaviorRelay(value: nil)
    var cameraItems: BehaviorRelay<[CamElement]?> = BehaviorRelay(value: nil)
    
    var localizer:LocalizerType
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer

        viewTitleText = localizer.localized("ttl_parking_status")
        parkingStatusDescText = localizer.localized("dsc_parking_time_remaining")
        directionGuideText = localizer.localized("btn_direction_guide")
        departueText = localizer.localized("btn_to_leave")
        reserveExtensionText = localizer.localized("btn_reservation_extension")
        
        confirmText = localizer.localized("btn_yes")
    }
    
    // MARK: - Public Methods
    
    public func getGuideText() -> Observable<String> {
        return loadUsages()
            .filter { $0 != nil }
            .map { $0! }
            .map {
                let elapsedTime = $0.elapsedMinutes
                return self.localizer.localized("ttl_parking_time_remaining", arguments: elapsedTime) as String
            }
    }
    
    public func setOrderElement(_ element:OrderElement) {
        orderElement = element
    }
    
    public func getUsagesItem() -> Observable<Usages> { //Observable<(supported:Bool, urls:[String], elapsedMinutes:Int)> {
        return loadUsages()
            .filter { $0 != nil }
            .map { $0! }
            /*
            .map {
                if $0.camIds.count > 0 {
                    return (supported:true, urls: $0.camIds, elapsedMinutes: $0.elapsedMinutes)
                } else {
                    return (supported:false, urls: $0.camIds,elapsedMinutes: $0.elapsedMinutes)
                }
            }
 */
    }
    
    public func getElapsedTime() -> Observable<Int> {
        return loadUsages()
            .filter { $0 != nil }
            .map { $0! }
            .map {
                return $0.elapsedMinutes
            }
    }
    
    public func getCameraList() -> Observable<[CamElement]> {
        /*
        return loadUsages()
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0.cctvGroupName != nil }
            .map { return $0.cctvGroupName! }
            .flatMap { [unowned self] groupName in
                return self.loadCameraList(with: groupName)
                    .filter { $0 != nil }
                    .map{ $0! }
            }
        */
        
        let groupName = "AT59459"
            
        return self.loadCameraList(with: groupName)
                           .filter {
                            $0 != nil
                            }
                           .map{ $0! }

    }
    
    // MARK: - Local Methods
    
    func updateUsageItem(_ item:Usages) {
        usageItem.accept(item)
    }
    
    // MARK: - Network
    
    func loadUsages() -> Observable<Usages?> {
        if let element = orderElement {
            if usageItem.value != nil {
                return usageItem.asObservable()
                    .filter { $0 != nil }
            } else {
                return Order.mypage_usages(id: element.id)
                    .asObservable()
                    .filter { (usages, status) in
                        status == .success && usages != nil
                    }
                    .map { [unowned self] (usages, status) in
                        self.updateUsageItem(usages!)
                        return usages
                    }
            }
        } else {
            return Observable.just(nil)
        }
    }
    
    func loginCam() -> Observable<CamLogin?> {
        if camLogin.value != nil {
            return camLogin.asObservable()
        } else {
            return CctvHttpSession.login()
                .asObservable()
                .filter { $0 != nil }
                .map { $0 }
        }
    }
    
    func loadCameraList(with groupName:String) -> Observable<[CamElement]?> {
        if cameraItems.value != nil {
            return cameraItems.asObservable()
        } else {
            return loginCam()
                .filter { $0 != nil }
                .map { $0! }
                .flatMap { camLogin in
                    return CctvHttpSession.getCamList(projectId: camLogin.projectId, projectAuth: camLogin.projectAuth, deviceId: CamInfo.deviceId, userId: groupName)
                        .filter { $0 != nil }
                        .map { $0! }
                        .map { $0.cameraList }
                }
        }
    }
}
