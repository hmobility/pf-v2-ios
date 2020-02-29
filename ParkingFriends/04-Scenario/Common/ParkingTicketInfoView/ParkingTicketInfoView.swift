//
//  ParkingTicketInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingTicketInfoViewType {
    func setParkingInfo(with usages:Usages)
}

class ParkingTicketInfoView: UIStackView, ParkingTicketInfoViewType {
    @IBOutlet weak var parkingBasicInfoView: ParkingTicketBasicInfoView!
    @IBOutlet weak var timeTicketInfoView: ParkingTicketTimeInfoView!
    @IBOutlet weak var fixedTicketInfoView: ParkingTicketFixedInfoView!
    @IBOutlet weak var monthlyTicketInfoView: ParkingTicketMonthlyInfoView!
    @IBOutlet weak var carInfoDisplayView: ParkingCarInfoDisplayView!
    
    private var infoUsage:BehaviorRelay<Usages?> = BehaviorRelay(value: nil) //  Order-Usage
    private var infoPreview:BehaviorRelay<OrderPreview?> = BehaviorRelay(value: nil) //  Order-Preview
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setParkingInfo(with usages:Usages) {
        infoUsage.accept(usages)
    }
    
    public func setParkingInfo(with preview:OrderPreview) {
          infoPreview.accept(preview)
      }
    
    // MARK: - Binding
    
    func setupBinding() {
        infoUsage.asObservable()
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [unowned self] usages in
                self.updateParkingInfo(with: usages)
            })
            .disposed(by: disposeBag)
        
        infoPreview.asObservable()
                .filter { $0 != nil }
                .map { $0! }
                .subscribe(onNext: { [unowned self] preview in
                    self.updateParkingInfo(with: preview)
                })
                .disposed(by: disposeBag)
    }
    
    // MARK: Usage
    
    func updateParkingInfo(with item:Usages) {
        if let orderItem = item.orderInfo, let parkinglot = orderItem.parkingLot, let productType = orderItem.type, let carInfo = orderItem.car {
            updateBasicInfo(name: parkinglot.name, productName:orderItem.productName, date: item.payDay)
            updateTicketInfo(with: productType, info:(desc1: item.desc1, desc2: item.desc2))
            updateCarInfo(with: carInfo.number)
        }
    }
    
    // MARK: Preview
    
    func updateParkingInfo(with item:OrderPreview) {
        if let productType = item.parkingItemType, let carInfo = item.cars.first  {
            let todayString = DisplayDateTimeHandler().displayDateYYmD(with: Date())
            updateBasicInfo(name: item.parkingLotName, productName: item.parkingLotName, date: todayString)
            updateTicketInfo(with: productType, info:(desc1: item.desc1, desc2: item.desc2))
            updateCarInfo(with: carInfo.carNo)
        }
    }
    
    // MARK: - Local Methods
    
    func updateBasicInfo(name:String, productName:String, date:String) {
        self.parkingBasicInfoView.setInfo(name: name, product: productName, date: date)
    }
    
    func updateCarInfo(with carNumber:String) {
        if carInfoDisplayView != nil {
            self.carInfoDisplayView.setInfo(number: carNumber)
        }
    }
    
    func updateTicketInfo(with type:ProductType, info:(desc1:String, desc2:String)) {
        setTicketInfoViewState(with: type)
        
        if type == .time{
            timeTicketInfoView.setInfo(date: info.desc1, time: info.desc2)
        } else if type == .fixed {
            fixedTicketInfoView.setInfo(time: info.desc1)
        } else if type == .monthly {
            monthlyTicketInfoView.setInfo(start: info.desc1, end: info.desc2)
        }
    }
    
    func setTicketInfoViewState(with type:ProductType) {
        timeTicketInfoView.isHidden = (type == .time) ? false : true
        fixedTicketInfoView.isHidden = (type == .fixed) ? false : true
        monthlyTicketInfoView.isHidden = (type == .monthly) ? false : true
    }
    
    func setInfoViewHidden(_ flag:Bool) {
        timeTicketInfoView.isHidden = flag
        fixedTicketInfoView.isHidden = flag
        monthlyTicketInfoView.isHidden = flag
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setInfoViewHidden(true)
        setupBinding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
    }
}
