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
    private var products:BehaviorRelay<[ProductElement]> = BehaviorRelay(value: [])             // 별개의 가격정보 리스트로 제공 되지 않아 ProductElement 를 사용
    
    private var baseFee:BehaviorRelay<Fee?> = BehaviorRelay(value: nil)
    
    private var viewModel: ParkinglotDetailPriceViewModelType = ParkinglotDetailPriceViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Public Methods

    public func getViewModel() -> ParkinglotDetailPriceViewModel? {
        return (viewModel as! ParkinglotDetailPriceViewModel)
    }
    
    // MARK: Local Methods
    
    func setHidden(_ flag:Bool) {
        if self.isHidden != flag {
            self.isHidden = flag
        }
    }
  
    // MARK: - Initializer

    private func initialize() {
        setupTableBinding()
        setupTitleBinding()
    }
    
    private func setupPriceTable() {
        setupTimeBinding()
        setupFixedBinding()
        setupMonthlyBinding()
    }
        
    // MARK: - Binding
    
    private func setupTitleBinding() {
        viewModel.viewTitleText
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTableBinding() {
        viewModel.isAvailable().asObservable()
            .subscribe(onNext: { [unowned self] available in
                self.setHidden(available ? false : true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTimeBinding() {
        viewModel.getTimeTicketList()
            .subscribe(onNext: { [unowned self] (title, result) in
                let itemView = ParkinglotDetailPriceItemView.loadFromXib() as! ParkinglotDetailPriceItemView
                itemView.setTimeTicket(title: title, price: result)
                self.priceTableView.addArrangedSubview(itemView)
            })
            .disposed(by: disposeBag)
        
        viewModel.getExtraFee()
            .subscribe(onNext: { [unowned self] text in
                self.extraFeeView.setGuideText(text)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFixedBinding() {
        viewModel.getFixedTicketList()
            .subscribe(onNext: { [unowned self] (title, price) in
                let itemView = ParkinglotDetailPriceItemView.loadFromXib() as ParkinglotDetailPriceItemView
                itemView.setFixedTicket(title: title, price: price)
                self.priceTableView.addArrangedSubview(itemView)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMonthlyBinding() {
        viewModel.getMonthlyTicketList()
            .subscribe(onNext: { [unowned self] (index, title, price) in
                let itemView = ParkinglotDetailMonthlyTicketPriceItemView.loadFromXib() as ParkinglotDetailMonthlyTicketPriceItemView
                let titleString = (index == 0) ? title : nil
                itemView.setMonthlyTicket(title: titleString, price: price, index: index)
                self.priceTableView.addArrangedSubview(itemView)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Drawings
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        initialize()
        
        setupPriceTable()
    }
}
