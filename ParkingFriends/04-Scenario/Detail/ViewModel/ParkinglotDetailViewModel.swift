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
    var noticeList: BehaviorRelay<[String]> { get }
    
    func loadDetailInfo()
    
    func setSymbolViewModel(_ viewModel:ParkinglotDetailSymbolViewModel)
    func setPriceViewModel(_ viewModel:ParkinglotDetailPriceViewModel)
    func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel)
    func setOperationTimeViewModel(_ viewModel:ParkinglotDetailOperationTimeViewModel)
    func setNoticeViewModel(_ viewModel:ParkinglotDetailNoticeViewModel)
}

class ParkinglotDetailViewModel: ParkinglotDetailViewModelType {
    var viewTitleText: Driver<String>
    var viewSubtitleText: Driver<String>
    
    var detailInfo: BehaviorRelay<Parkinglot?> = BehaviorRelay(value: nil)
    
    var imageList: BehaviorRelay<[ImageElement]> = BehaviorRelay(value: [])
    var markSymbolList: BehaviorRelay<[SymbolType]> = BehaviorRelay(value: [])

    var noticeList: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    private var localizer:LocalizerType

    private let disposeBag = DisposeBag()
    
    private var within:WithinElement?
    private let userData:UserData?
    
    private var symbolViewModel:ParkinglotDetailSymbolViewModelType?
    private var priceViewModel:ParkinglotDetailPriceViewModelType?
    private var operationTimeViewModel:ParkinglotDetailOperationTimeViewModelType?
    private var reserveViewModel:ParkinglotDetailReserveViewModelType?
    private var noticeViewModel:ParkinglotDetailNoticeViewModelType?
    
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
    
    func setSymbolViewModel(_ viewModel:ParkinglotDetailSymbolViewModel) {
        symbolViewModel = viewModel
    }
    
    func setPriceViewModel(_ viewModel:ParkinglotDetailPriceViewModel) {
        priceViewModel = viewModel
    }
    
    func setOperationTimeViewModel(_ viewModel:ParkinglotDetailOperationTimeViewModel) {
        operationTimeViewModel = viewModel
    }
    
    func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel) {
        reserveViewModel = viewModel
    }
    
    func setNoticeViewModel(_ viewModel:ParkinglotDetailNoticeViewModel) {
        noticeViewModel = viewModel
    }
    
    // MARK: - Local Methods
    
    func upateDetailInfo(_ element:Parkinglot) {
        if element.images.count > 0 {
            updateParkinglotImage(element.images)
        }
        
        if let flags = element.flagElements {
            updateParkingSymbol(flags)
        }
        
        if element.supportItems.count > 0 {
            updatePriceTable(element.supportItems, baseFee: element.baseFee)
        }
        
        if element.notices.count > 0 {
            updateNoticeItems(element.notices)
        }
        
        if element.operationTimes.count > 0 {
            updateOperationTime(element.operationTimes)
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
    
    func updateOperationTime(_ items:[ParkinglotOperationTime]) {
        if let viewModel = operationTimeViewModel {
            viewModel.setOperationTimes(items)
        }
    }
    
    // MARK: - Price Table
    
    func updatePriceTable(_ items:[ProductType], baseFee fee:Fee?) {
        if let viewModel = priceViewModel {
            viewModel.setSupported(items, fee: fee)
        }
    }
    
    // MARK: - Symbol
    
    func updateParkingSymbol(_ item:FlagElement) {
        if let viewModel = symbolViewModel {
            viewModel.setParkingSymbols(item)
        }
    }
    
    // MARK: - Reserve
    
    func updateReserveTime(_ items:[ProductElement], onReserve duration:DateDuration) {
        if let viewModel = reserveViewModel {
            viewModel.setProducts(items, onReserve:duration)
        }
    }
    
    // MARK: - Notice
      
    func updateNoticeItems(_ items:[String]) {
        if let viewModel = noticeViewModel {
            viewModel.setContents(items)
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
