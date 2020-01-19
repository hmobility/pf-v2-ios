//
//  ParkinglotDetailOperationgTimeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailOperationgTimeItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    private var localizer:LocalizerType = Localizer.shared

    private let disposeBag = DisposeBag()
    
    public func setOperationTime(with time:String) {
        descLabel.text = time
    }
}

class ParkinglotDetailOperationTimeView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weekdayView: ParkinglotDetailOperationgTimeItemView!
    @IBOutlet weak var saturdayView: ParkinglotDetailOperationgTimeItemView!
    @IBOutlet weak var sundayView: ParkinglotDetailOperationgTimeItemView!
    @IBOutlet weak var holidayView: ParkinglotDetailOperationgTimeItemView!
    
    private var operationTimeList:BehaviorRelay<[ParkinglotOperationTime]> = BehaviorRelay(value: [])
  
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Initializer

    private func initialize() {
        setupBinding()
        setupTimeBinding()
    }
    
    // MARK: - Public Methods
    
    public func setOperationTimeList(_ items:[ParkinglotOperationTime]) {
        operationTimeList.accept(items)
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        localizer.localized("ttl_detail_operating_time")
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("ttl_operationg_time_weekday")
            .asDriver()
            .drive(self.weekdayView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("txt_day_closed")
            .asDriver()
            .drive(self.weekdayView.descLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("ttl_operationg_time_saturday")
            .asDriver()
            .drive(self.saturdayView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("txt_day_closed")
            .asDriver()
            .drive(self.saturdayView.descLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("ttl_operationg_time_sunday")
              .asDriver()
              .drive(self.sundayView.titleLabel.rx.text)
              .disposed(by: disposeBag)
          
        localizer.localized("txt_day_closed")
              .asDriver()
              .drive(self.sundayView.descLabel.rx.text)
              .disposed(by: disposeBag)
        
        localizer.localized("ttl_operationg_time_holiday")
            .asDriver()
            .drive(self.holidayView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("txt_day_closed")
            .asDriver()
            .drive(self.holidayView.descLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTimeBinding() {
        operationTimeList
            .asObservable()
            .flatMap {
                Observable.from($0)
            }
            .filter {
                $0.operationFlag
            }
            .subscribe(onNext:{ item in
                let time = DisplayTimeHandler().displayOperationTime(start: item.from, end: item.to)
                switch item.type {
                case .holiday:
                    self.holidayView.setOperationTime(with: time)
                case .weekday:
                    self.weekdayView.setOperationTime(with: time)
                case .sunday:
                    self.sundayView.setOperationTime(with: time)
                case .saturday:
                    self.saturdayView.setOperationTime(with: time)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
