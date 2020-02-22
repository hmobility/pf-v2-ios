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
    @IBOutlet weak var carInfoView: ParkingCarInfoView!
    
    private var infoItem:BehaviorRelay<Usages?> = BehaviorRelay(value: nil)
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setParkingInfo(with usages:Usages) {
        infoItem.accept(usages)
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        infoItem.asObservable()
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [unowned self] usages in
                self.updateParkingInfo(with: usages)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Local Methods
    
    func updateParkingInfo(with item:Usages) {
        if let orderItem = item.orderInfo, let productType = orderItem.type, let carInfo = orderItem.car {
            updateBasicInfo(with: orderItem, date: item.payDay)
            updateTicketInfo(with: productType, data:item)
            updateCarInfo(with: carInfo)
        }
    }
    
    func updateBasicInfo(with orderInfo:UsageOrderInfo, date:String) {
        if let info = orderInfo.parkingLot {
            self.parkingBasicInfoView.setInfo(name: info.name, product: orderInfo.productName, date: date)
        }
    }
    
    func updateCarInfo(with carInfo:UsageCar) {
        self.carInfoView.setInfo(number: carInfo.number)
    }
    
    func updateTicketInfo(with type:ProductType, data:Usages) {
        setTicketInfoViewState(with: type)
        
        if type == .time {
            timeTicketInfoView.setInfo(date: data.desc1, time: data.desc2)
        } else if type == .fixed {
            fixedTicketInfoView.setInfo(time: data.desc1)
        } else if type == .monthly {
            monthlyTicketInfoView.setInfo(start: data.desc1, end: data.desc2)
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
