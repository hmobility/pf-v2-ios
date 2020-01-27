//
//  ParkinglotDetailViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/07.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

typealias SymbolType = (title:String, image:UIImage)

protocol ParkinglotDetailViewModelType {
    var viewTitleText: Driver<String> { get }
    var viewSubtitleText: Driver<String> { get }
    
    var detailInfo: BehaviorRelay<Parkinglot?> { get }
    
    var imageList: BehaviorRelay<[ImageElement]> { get }
    var markSymbolList: BehaviorRelay<[SymbolType]> { get }
    var operationTimeList: BehaviorRelay<[ParkinglotOperationTime]> { get }
    var noticeList: BehaviorRelay<[String]> { get }
    
    func loadDetailInfo()
    
    func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel)
}

class ParkinglotDetailViewModel: ParkinglotDetailViewModelType {
    var viewTitleText: Driver<String>
    var viewSubtitleText: Driver<String>
    
    var detailInfo: BehaviorRelay<Parkinglot?> = BehaviorRelay(value: nil)
    
    var imageList: BehaviorRelay<[ImageElement]> = BehaviorRelay(value: [])
    var markSymbolList: BehaviorRelay<[SymbolType]> = BehaviorRelay(value: [])
    var operationTimeList: BehaviorRelay<[ParkinglotOperationTime]> = BehaviorRelay(value: [])
    var noticeList: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    private var localizer:LocalizerType

    private let disposeBag = DisposeBag()
    
   // private var parkinglot:Parkinglot?
    private var within:WithinElement?
    private let userData:UserData?
    
    private var reserveViewModel:ParkinglotDetailReserveViewModelType?
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, within:WithinElement, userData:UserData = UserData.shared) {
        self.localizer = localizer
        self.userData = userData
        self.within = within
        
        viewTitleText = Driver.just(within.name)
        viewSubtitleText = Driver.just(within.address)
        
        initialize()
    }
    
    func initialize() {
        detailInfo.asDriver()
            .drive(onNext: { element in
                if let data = element {
                    self.upateDetailInfo(data)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Binding
    
    func setupParkinglotInfo() {
        
    }
    
    // MARK: - Public Methods
    
    func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel) {
        reserveViewModel = viewModel
    }
    
    // MARK: - Local Methods
    
    func upateDetailInfo(_ element:Parkinglot) {
        if element.images.count > 0 {
            updateParkinglotImage(element.images)
        }
        
        if let flags = element.flagElements {
            updateParkingSymbols(flags)
        }
        
        if element.notices.count > 0 {
            updateNotice(element.notices)
        }
        
        if element.operationTimes.count > 0 {
            udpateOperationTime(element.operationTimes)
        }
        
        if element.products.count > 0, let data = userData {
            updateReserveTime(element.products, onReserve: data.getOnReserveDate())
        }
    }
    
    // MARK: - Header
    
    func updateParkinglotImage(_ images:[ImageElement]) {
        imageList.accept(images)
    }

    // MARK: - Operation Time
    
    func udpateOperationTime(_ items:[ParkinglotOperationTime]) {
        operationTimeList.accept(items)
    }
    
    // MARK: - Notice
    
    func updateNotice(_ items:[String]) {
        noticeList.accept(items)
    }
    
    // MARK: - Reserve
    
    func updateReserveTime(_ items:[ProductElement], onReserve duration:DateDuration) {
        if let viewModel = reserveViewModel {
            viewModel.setProducts(items, onReserve:duration)
        }
    }
    
    // MARK: - Network
    
    func loadDetailInfo() {
        if let element = self.within {
            parkinglot(id: element.id)
                .asObservable()
                .bind(to: detailInfo)
                .disposed(by: disposeBag)
        }
    }
    
    func parkinglot(id:Int) -> Observable<Parkinglot?> {
        ParkingLot.parkinglots(id: id, from: "201010161200", to: "201001161600", type: .time, monthlyFrom: "20100116", monthlyCount: 1)
            .asObservable()
            .map { (parkinglot, code) in
                return parkinglot
            }
    }
    
    func bookmark(id:Int) {
       
    }
}

// MARK: - Symbol

extension ParkinglotDetailViewModel {

func updateParkingSymbols(_ flagElements:FlagElement) {
    let symbols = getParkinglotSymbols(flagElements)
    
    markSymbolList.accept(symbols)
}

func getParkinglotSymbols(_ flagElements:FlagElement) -> [SymbolType] {
    var symbols:[(title:String, image:UIImage)] = []
    
    if flagElements.bleGateFlag {
        symbols.append((self.localizer.localized("itm_symbol_ble_gate"), UIImage(named:"icParkingLotInfoType21Outdoor")!))
    }
    
    if flagElements.cctvFlag {
        symbols.append((self.localizer.localized("itm_symbol_cctv"), UIImage(named:"icParkingLotInfoType3Cctv")!))
    }
    
    if flagElements.chargerFlag {
        symbols.append((self.localizer.localized("itm_symbol_charger"), UIImage(named:"icParkingLotInfoType3Electric")!))
    }
    
    if flagElements.iotSensorFlag {
        symbols.append((self.localizer.localized("itm_symbol_iot_sensor"), UIImage(named:"icParkingLotInfoType3Sensor")!))
    }
    
    if flagElements.outsideFlag {
        symbols.append((self.localizer.localized("itm_symbol_outdoor"), UIImage(named:"icParkingLotInfoType21Outdoor")!))
    } else {
        symbols.append((self.localizer.localized("itm_symbol_indoor"), UIImage(named:"icParkingLotInfoType22Indoor")!))
    }
    
    if flagElements.partnerFlag {
        symbols.append((self.localizer.localized("itm_symbol_partner"), UIImage(named:"icParkingLotInfoType14AffiliateAj")!))
    }
    
    return symbols
    }
}
