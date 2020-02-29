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
    
    var parkinglotInfo: BehaviorRelay<Parkinglot?> { get }
    
    func loadInfo()
    func changeBookmark(_ state:Bool)
    
    func getSelectedProductType() -> Observable<ProductType?>
    func getExpectedProductInfo() -> ExpectedProductInfo?
    
    func getParkinglotInfo() -> Parkinglot?
    
    func setHeaderViewModel(_ viewModel:ParkinglotDetailHeaderViewModel)
    func setSymbolViewModel(_ viewModel:ParkinglotDetailSymbolViewModel)
    func setPriceViewModel(_ viewModel:ParkinglotDetailPriceViewModel)
    func setReserveViewModel(_ viewModel:ParkinglotDetailReserveViewModel)
    func setEditScheduleViewModel(_ viewModel:ParkinglotDetailEditTimeViewModel)
    func setOperationTimeViewModel(_ viewModel:ParkinglotDetailOperationTimeViewModel)
    func setNoticeViewModel(_ viewModel:ParkinglotDetailNoticeViewModel)
    func setButtonViewModel(_ viewModel:ParkinglotDetailButtonViewModel)

    func getReadyStateForOrder() -> Observable<Bool>
    func getValidOrderForm() -> TicketOrderFormType?
    
    func setExpectedProduct(type:ProductType, parkinglotId:Int, productId:Int?, time:DateDuration?, monthly:MonthlyDuration?, quantity:Int, updateSetting:Bool)
}

class ParkinglotDetailViewModel: ParkinglotDetailViewModelType {
    var viewTitleText: Driver<String>?
    var viewSubtitleText: Driver<String>?
    
    var parkinglotInfo: BehaviorRelay<Parkinglot?> = BehaviorRelay(value: nil)
    
    var productSetting:ProductSetting?
    
    var headerViewModel:ParkinglotDetailHeaderViewModelType?
    var symbolViewModel:ParkinglotDetailSymbolViewModelType?
    var priceViewModel:ParkinglotDetailPriceViewModelType?
    var operationTimeViewModel:ParkinglotDetailOperationTimeViewModelType?
    var reserveViewModel:ParkinglotDetailReserveViewModelType?
    var editScheduleViewModel: ParkinglotDetailEditTimeViewModelType?
    var noticeViewModel:ParkinglotDetailNoticeViewModelType?
    var buttonViewModel:ParkinglotDetailButtonViewModelType?
    
    var orderForm:BehaviorRelay<TicketOrderFormType?> =  BehaviorRelay(value:nil)
    
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
        parkinglotInfo.asDriver()
            .drive(onNext: { [unowned self] element in
                if let data = element {
                    self.updateDetailInfo(data)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Bookmark
    
    func changeBookmark(_ state:Bool) {
        if let id = parkinglotId {
            self.bookmark(id: id, favorite: state)
        }
    }
    
    // MARK: - Public Methods
    
    // The booking data for user's selected
    public func getExpectedProductInfo() -> ExpectedProductInfo? {
        if let settings = productSetting {
            return settings.getProductAllSet()
        } else {
            return nil
        }
    }
    
    public func setExpectedProduct(type:ProductType, parkinglotId:Int, productId:Int?, time:DateDuration? = nil, monthly:MonthlyDuration? = nil, quantity:Int, updateSetting:Bool = false) {
      
        if updateSetting, let form = updateProductSetting(type:type, parkinglotId: parkinglotId, productId: productId, from: time?.start, to: time?.end, count: monthly?.count ?? 1, quantity: quantity) {
            self.setOrderForm(form)
        } else {
            let form = TicketOrderFormType(type:type, parkingLotId:parkinglotId, productId:productId, from: time?.start, to: time?.end, count: monthly?.count ?? 1, quantity: quantity)
            self.setOrderForm(form)
        }
    }
    
    // MARK: Handle Order Form
    
    public func getReadyStateForOrder() -> Observable<Bool> {
        return orderForm
            .asObservable()
            .map { return self.checkOrderForm($0) }
            .map { return ($0 !=  nil) ? true : false}
    }
    
    public func getValidOrderForm() -> TicketOrderFormType? {
        return checkOrderForm(self.orderForm.value)
    }
    
    func setOrderForm(_ form:TicketOrderFormType) {
          orderForm.accept(form)
    }
    
    func checkOrderForm(_ orderForm:TicketOrderFormType?) -> TicketOrderFormType? {
        if let form = orderForm {
            if form.productId != nil, (form.type == .fixed || form.type == .monthly) {
                return form
            } else if form.type == .time {
                return form
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    // MARK: - Local Methods
    
    func updateProductSetting(type:ProductType, parkinglotId:Int, productId:Int?, from:Date?, to:Date?, count:Int, quantity:Int) -> TicketOrderFormType? {
        if let settings = productSetting {
            if type == .time, let dateFrom = from, let dateTo = to {
                settings.setProduct(type: .time).save()
                settings.setBookingTime(start: dateFrom, end: dateTo)
            } else if type == .monthly, let dateFrom = from {
                settings.setProduct(type: .monthly).save()
                settings.setBookingMonthly(from: dateFrom, count: count)
            } else if type == .fixed, let dateFrom = from, let dateTo = to {
                settings.setProduct(type: .fixed).save()
                settings.setBookingTime(start: dateFrom, end: dateTo)
            }
            
            return TicketOrderFormType(type:type, parkingLotId:parkinglotId, productId:productId, from: from, to: to, count: count, quantity: quantity)
        } else {
            return nil
        }
    }
    
    func setupInitOrderForm(with products:[ProductElement]) {
        if let setting = productSetting {
            let type = setting.getProductType()
            
            if let parkingId = self.parkinglotId, let item = products.first(where: { $0.type == type }) {
                let bookingDate = setting.getBookingDate()
             
                setExpectedProduct(type: type, parkinglotId: parkingId, productId: item.id, time: bookingDate, monthly: setting.bookingMonthly, quantity: 1, updateSetting: false)
            }
        }
    }

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
            updateBookingTime(supported: element.supportItems, items: element.products, onReserve: data.getBookingDate())
            updateBookableState(bookable)
            setupInitOrderForm(with: element.products)
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
                .bind(to: parkinglotInfo)
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

// MARK: - Update Sub View Model

extension ParkinglotDetailViewModel {
    
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
        
        if let viewModel = editScheduleViewModel {
            viewModel.setProducts(supported: products, items: items)
        }
    }
    
    func getSelectedProductType() -> Observable<ProductType?> {
        if let viewModel = reserveViewModel {
            return viewModel.getSelectedProductType()
        }
        
        return Observable.just(nil)
    }
    
    // MARK: - Notice
    
    func updateNoticeItems(_ items:[String]) {
        if let viewModel = noticeViewModel {
            viewModel.setContents(items)
        }
    }
    
    // MARK: - Bookable State
    
    func updateBookableState(_ enabled:Bool) {
        if let viewModel = buttonViewModel {
            viewModel.setBookableState(enabled)
        }
    }
}

// MARK: - View Model Setter/Getter

extension ParkinglotDetailViewModel {
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
    
    public func setEditScheduleViewModel(_ viewModel:ParkinglotDetailEditTimeViewModel) {
        editScheduleViewModel = viewModel
    }
    
    public func setNoticeViewModel(_ viewModel:ParkinglotDetailNoticeViewModel) {
        noticeViewModel = viewModel
    }
    
    public func setButtonViewModel(_ viewModel:ParkinglotDetailButtonViewModel) {
        buttonViewModel = viewModel
    }
    
    public func getParkinglotInfo() -> Parkinglot? {
        return self.parkinglotInfo.value
    }
}
