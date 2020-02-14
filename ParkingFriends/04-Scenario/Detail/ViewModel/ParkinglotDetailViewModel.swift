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
    var viewTitleText: Driver<String>? { get }
    var viewSubtitleText: Driver<String>? { get }
    
    var detailInfo: BehaviorRelay<Parkinglot?> { get }
    
    func loadInfo()
    func changeBookmark(_ state:Bool) 
    func getSelectedProductType() -> Observable<ProductType>?
    
    func setHeaderViewModel(_ viewModel:ParkinglotDetailHeaderViewModel)
    func setSymbolViewModel(_ viewModel:ParkinglotDetailSymbolViewModel)
    func setPriceViewModel(_ viewModel:ParkinglotDetailPriceViewModel)
    func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel)
    func setEditTimeViewModel(_ viewModel:ParkinglotDetailEditTimeViewModel)
    func setOperationTimeViewModel(_ viewModel:ParkinglotDetailOperationTimeViewModel)
    func setNoticeViewModel(_ viewModel:ParkinglotDetailNoticeViewModel)
    func setButtonViewModel(_ viewModel:ParkinglotDetailButtonViewModel)
}

class ParkinglotDetailViewModel: ParkinglotDetailViewModelType {
    var viewTitleText: Driver<String>?
    var viewSubtitleText: Driver<String>?
    
    var detailInfo: BehaviorRelay<Parkinglot?> = BehaviorRelay(value: nil)
    
    let productSetting:ProductSetting?
    
    var headerViewModel:ParkinglotDetailHeaderViewModelType?
    var symbolViewModel:ParkinglotDetailSymbolViewModelType?
    var priceViewModel:ParkinglotDetailPriceViewModelType?
    var operationTimeViewModel:ParkinglotDetailOperationTimeViewModelType?
    var reserveViewModel:ParkinglotDetailReserveViewModelType?
    var editTimeViewModel: ParkinglotDetailEditTimeViewModelType?
    var noticeViewModel:ParkinglotDetailNoticeViewModelType?
    var buttonViewModel:ParkinglotDetailButtonViewModelType?
    
    var localizer:LocalizerType

    let disposeBag = DisposeBag()
    
    var parkinglotId:Int?
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, within:WithinElement? = nil, favorite:FavoriteElement? = nil, productSetting:ProductSetting = ProductSetting.shared) {
        self.localizer = localizer
        self.productSetting = productSetting
        
        if let item = within {
            viewTitleText = Driver.just(item.name)
            viewSubtitleText = Driver.just(item.address)
            parkinglotId = item.id
        }
        
        if let item = favorite {
            viewTitleText = Driver.just(item.name)
            viewSubtitleText = Driver.just(item.address)
            parkinglotId = item.parkinglot?.id
        }
        
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
    
    // MARK: - View Model Setter
    
    public func setHeaderViewModel(_ viewModel:ParkinglotDetailHeaderViewModel) {
        headerViewModel = viewModel
        
        if let viewModel = headerViewModel {
            viewModel.setDetailModelView(self)
        }
    }
    
    public func setSymbolViewModel(_ viewModel:ParkinglotDetailSymbolViewModel) {
        symbolViewModel = viewModel
    }
    
    public func setPriceViewModel(_ viewModel:ParkinglotDetailPriceViewModel) {
        priceViewModel = viewModel
    }
    
    public func setOperationTimeViewModel(_ viewModel:ParkinglotDetailOperationTimeViewModel) {
        operationTimeViewModel = viewModel
    }
    
    public func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel) {
        reserveViewModel = viewModel
    }
    
    public func setEditTimeViewModel(_ viewModel:ParkinglotDetailEditTimeViewModel) {
        editTimeViewModel = viewModel
    }
    
    public func setNoticeViewModel(_ viewModel:ParkinglotDetailNoticeViewModel) {
        noticeViewModel = viewModel
    }
    
    public func setButtonViewModel(_ viewModel:ParkinglotDetailButtonViewModel) {
        buttonViewModel = viewModel
    }
    
    // MARK: - Bookmark
    
    func changeBookmark(_ state:Bool) {
        if let id = parkinglotId {
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
        
        if element.products.count > 0, let data = productSetting {
            let bookable:Bool = element.products.count > 0
            updateBookingTime(supported:element.supportItems, items: element.products, onReserve: data.getBookingDate())
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
    
    func updateBookingTime(supported products:[ProductType], items:[ProductElement], onReserve duration:DateDuration) {
        if let viewModel = reserveViewModel {
            viewModel.setProducts(supported: products, elements: items, onReserve: duration)
        }
        
        if let viewModel = editTimeViewModel {
            viewModel.setProducts(supported: products, items: items)
        }
    }
    
    func getSelectedProductType() -> Observable<ProductType>? {
        if let viewModel = reserveViewModel {
            return viewModel.getSelectedProductType()
        }
        
        return nil
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
        if let elementId = parkinglotId, let settings = productSetting {
            let productType = settings.selectedProductType
            let time = settings.getBookingTime()
            let monthly = settings.getBookingMonthly()
      
            parkinglot(id: elementId, from: time.start, to: time.end, type:productType, monthly:(from: monthly.from, count: monthly.count))
                .asObservable()
                .bind(to: detailInfo)
                .disposed(by: disposeBag)
        }
    }
    
    func parkinglot(id:Int, from:String, to:String, type:ProductType, monthly:(from:String, count:Int)) -> Observable<Parkinglot?> {
        ParkingLot.parkinglots(id: id, from: from, to: to, type: type, monthlyFrom: monthly.from, monthlyCount: monthly.count)
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
