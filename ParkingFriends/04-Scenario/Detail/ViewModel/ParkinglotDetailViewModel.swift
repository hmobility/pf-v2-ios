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
    
    func loadInfo()
    func changeBookmark(_ state:Bool) 
    
    func setHeaderViewModel(_ viewModel:ParkinglotDetailHeaderViewModel)
    func setSymbolViewModel(_ viewModel:ParkinglotDetailSymbolViewModel)
    func setPriceViewModel(_ viewModel:ParkinglotDetailPriceViewModel)
    func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel)
    func setOperationTimeViewModel(_ viewModel:ParkinglotDetailOperationTimeViewModel)
    func setNoticeViewModel(_ viewModel:ParkinglotDetailNoticeViewModel)
    func setButtonViewModel(_ viewModel:ParkinglotDetailButtonViewModel)
}

class ParkinglotDetailViewModel: ParkinglotDetailViewModelType {
    var viewTitleText: Driver<String>
    var viewSubtitleText: Driver<String>
    
    var detailInfo: BehaviorRelay<Parkinglot?> = BehaviorRelay(value: nil)
    
    private var within:WithinElement?
    private let userData:UserData?
    
    private var headerViewModel:ParkinglotDetailHeaderViewModelType?
    private var symbolViewModel:ParkinglotDetailSymbolViewModelType?
    private var priceViewModel:ParkinglotDetailPriceViewModelType?
    private var operationTimeViewModel:ParkinglotDetailOperationTimeViewModelType?
    private var reserveViewModel:ParkinglotDetailReserveViewModelType?
    private var noticeViewModel:ParkinglotDetailNoticeViewModelType?
    private var buttonViewModel:ParkinglotDetailButtonViewModelType?
    
    private var localizer:LocalizerType

    private let disposeBag = DisposeBag()
    
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
                    self.updateDetailInfo(data)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public Methods
    
    func setHeaderViewModel(_ viewModel:ParkinglotDetailHeaderViewModel) {
        headerViewModel = viewModel
        
        if let viewModel = headerViewModel {
            viewModel.setDetailModelView(self)
        }
    }
    
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
    
    func setButtonViewModel(_ viewModel:ParkinglotDetailButtonViewModel) {
        buttonViewModel = viewModel
    }
    
    // MARK: - Bookmark
    
    func changeBookmark(_ state:Bool) {
        if let id = within?.id {
            self.bookmark(id: id, favorite: state)
        }
    }
    
    // MARK: - Local Methods

    func updateDetailInfo(_ element:Parkinglot) {
        
        updateFavorite(check: element.favoriteFlag)
        
        if element.images.count > 0 {
            updateHeaderImage(element.images)
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
            let bookable:Bool = element.products.count > 0
            updateReserveTime(supported:element.supportItems, items: element.products, onReserve: data.getOnReserveDate())
            udpateBookableState(bookable)
        }
    }
    
    // MARK: - Header
    
    func updateHeaderImage(_ images:[ImageElement]) {
        if let viewModel = headerViewModel {
            viewModel.setHeaderImages(images)
        }
    }
    
    func updateFavorite(check flag:Bool) {
        if let viewModel = headerViewModel {
            viewModel.setFavorite(flag)
        }
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
    
    func updateReserveTime(supported products:[ProductType], items:[ProductElement], onReserve duration:DateDuration) {
        if let viewModel = reserveViewModel {
            viewModel.setProducts(supported: products, elements: items, onReserve: duration)
        }
    }
    
    // MARK: - Notice
      
    func updateNoticeItems(_ items:[String]) {
        if let viewModel = noticeViewModel {
            viewModel.setContents(items)
        }
    }
    
    // MARK: - Button
    
    func udpateBookableState(_ enabled:Bool) {
        if let viewModel = buttonViewModel {
            viewModel.setBookableState(enabled)
        }
    }
    
    // MARK: - Network
    
    func loadInfo() {
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
    
    func bookmark(id:Int, favorite:Bool) {
        if favorite {
            ParkingLot.favorites(parkinglotId: id)
                .asObservable()
                .subscribe(onNext: { code in
                    let changed:Bool = (code == .success) ? true : false
                    self.updateFavorite(check: changed)
                })
                .disposed(by: disposeBag)
        } else {
            ParkingLot.delete_favorites(parkinglotId: id)
                .asObservable()
                .subscribe(onNext: { code in
                    let changed:Bool = (code == .success) ? false : true
                    self.updateFavorite(check: changed)
                })
                .disposed(by: disposeBag)
        }
    }
}
