//
//  ParkinglotDetailPriceInfoView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/17.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class PriceItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descFirstLabel: UILabel!
    @IBOutlet weak var descSecondLabel: UILabel!
    @IBOutlet weak var descThirdLabel: UILabel!
}

class ParkinglotDetailPriceInfoView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeView: PriceItemView!
    @IBOutlet weak var monthlyView: PriceItemView!
    @IBOutlet weak var extraFeeView: PriceItemView!
    
    private var supportedItems:BehaviorRelay<[ProductType]> = BehaviorRelay(value: [])
    private var baseFee:BehaviorRelay<Fee?> = BehaviorRelay(value: nil)
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Public Methods
    
    func setSupported(_ items:[ProductType], fee:Fee?) {
        supportedItems.accept(items)
        baseFee.accept(fee)
    }
    
    // MARK: Local Methods
    
    func udpatePriceTable() {
        supportedItems.asObservable()
            .subscribe(onNext: { items in
                self.timeView.isHidden = items.contains(.time) ? false : true
                self.extraFeeView.isHidden = items.contains(.time) ? false : true
                self.monthlyView.isHidden = items.contains(.monthly) ? false : true
            }).disposed(by: disposeBag)
   
        baseFee.asObservable()
            .filter({
                return ($0 != nil)
            })
            .map { fee in
                let minutes = fee!.minute
                let price = (minutes >= 60) ? (minutes / 60) : minutes
                let priceUnit = self.localizer.localized("txt_money_unit") as String
                let timeUnit:String = (minutes >= 60) ? self.localizer.localized("txt_hours") : self.localizer.localized("txt_minutes")
                return "\(price.withComma)\(priceUnit) / \(timeUnit)"
            }
            .subscribe(onNext: { result in
                self.timeView.descFirstLabel.text = result
            })
            .disposed(by: disposeBag)
        
        baseFee.asObservable()
            .filter({
                return ($0 != nil)
            })
            .map { fee in
                let minutes = String(fee!.addMinute)
                let timeUnit:String = (fee!.addMinute >= 60) ? self.localizer.localized("txt_hours") : self.localizer.localized("txt_minutes")
                let text = self.localizer.localized("txt_detail_time_extra_fee", arguments: minutes, timeUnit) as String
                return text
            }
            .subscribe(onNext: { result in
                self.extraFeeView.titleLabel.text = result
            }).disposed(by: disposeBag)
    }

    // MARK: - Initializer

    private func initialize() {
        setupBinding()
        udpatePriceTable()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        localizer.localized("ttl_detail_operating_time")
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("ttl_ticket_time")
            .asDriver()
            .drive(self.timeView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("ttl_ticket_monthly")
            .asDriver()
            .drive(self.monthlyView.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    // MARK: - Drawings
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
