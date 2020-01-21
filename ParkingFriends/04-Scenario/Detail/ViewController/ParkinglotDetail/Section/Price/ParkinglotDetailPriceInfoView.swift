//
//  ParkinglotDetailPriceInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/17.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailPriceInfoView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceTableView: UIStackView!
    @IBOutlet weak var extraFeeView: ParkinglotDetailExtraFeeItemView!
    
    private var supportedItems:BehaviorRelay<[ProductType]> = BehaviorRelay(value: [])
    private var products:BehaviorRelay<[ProductElement]> = BehaviorRelay(value: [])             // 별개의 가격정보 리스트로 제공 되지 ProductElement 를 사용
    
    private var baseFee:BehaviorRelay<Fee?> = BehaviorRelay(value: nil)
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Public Methods
    
    func setSupported(_ items:[ProductType], fee:Fee?) {
        supportedItems.accept(items)
        baseFee.accept(fee)
    }
    
    // MARK: Local Methods
    
    func udpateTimePriceTable() {
        supportedItems.asObservable()
            .subscribe(onNext: { items in
                self.extraFeeView.isHidden = items.contains(.time) ? false : true
            })
            .disposed(by: disposeBag)
       
        baseFee.asObservable()
            .filter ({
                return ($0 != nil)
            })
            .map { $0! }
            .map ({ fee -> String in
                let minutes = fee.minute
                let price = (minutes >= 60) ? (minutes / 60) : minutes
                let priceUnit = self.localizer.localized("txt_money_unit") as String
                let timeUnit:String = (minutes >= 60) ? self.localizer.localized("txt_hours") : self.localizer.localized("txt_minutes")
               
                return "\(price.withComma)\(priceUnit) / \(timeUnit)"
            })
            .subscribe(onNext: { [unowned self] result in
                let itemView = ParkinglotDetailPriceItemView.loadFromXib() as! ParkinglotDetailPriceItemView
                let title = self.localizer.localized("ttl_ticket_time") as String
                itemView.setTimeTicket(title: title, price: result)
                self.priceTableView.addArrangedSubview(itemView)
            })
            .disposed(by: disposeBag)
         
        baseFee.asObservable()
            .filter({
                return ($0 != nil)
            })
            .map { $0! }
            .map { fee -> String in
                let minutes = String(fee.addMinute)
                let timeUnit:String = (fee.addMinute >= 60) ? self.localizer.localized("txt_hours") : self.localizer.localized("txt_minutes")
                let text = self.localizer.localized("txt_detail_time_extra_fee", arguments: minutes, timeUnit) as String
                
                return text
            }
            .subscribe(onNext: { [unowned self] text in
                self.extraFeeView.setGuideText(text)
            })
            .disposed(by: disposeBag)

    }
    
    func udpateFixedPriceTable() {
        products.asObservable()
            .flatMap {
                Observable.from($0)
            }
            .filter {
                $0.type == .fixed
            }
            .subscribe(onNext: { [unowned self] element in
                let itemView = ParkinglotDetailPriceItemView.loadFromXib() as ParkinglotDetailPriceItemView
                itemView.setFixedTicket(title: element.name, price: element.price.withComma)
                self.priceTableView.addArrangedSubview(itemView)
            })
            .disposed(by: disposeBag)
    }
    
    func udpateMonthlyPriceTable() {
        products.asObservable()
            .flatMap {
                Observable.from($0)
            }
            .filter {
                $0.type == .monthly
            }
            .enumerated()
            .subscribe(onNext: { [unowned self] (index, element) in
                //  let price = "\(element.price.withComma)\(self.localizer.localized("txt_money_unit") as String)"
                let itemView = ParkinglotDetailMonthlyTicketPriceItemView.loadFromXib() as ParkinglotDetailMonthlyTicketPriceItemView
                let title = (index == 0) ? self.localizer.localized("ttl_ticket_monthly") as String : nil
                itemView.setMonthlyTicket(title: title, price: element.descript, index: index)
                self.priceTableView.addArrangedSubview(itemView)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Initializer

    private func initialize() {
        setupBinding()
    }
    
    private func updatePriceTable() {
        udpateTimePriceTable()
        udpateFixedPriceTable()
        udpateMonthlyPriceTable()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        localizer.localized("ttl_detail_price_table")
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    // MARK: - Drawings
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        updatePriceTable()
    }
}
