//
//  ParkinglotDetailEditTimeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkinglotDetailEditScheduleViewType {
   // func setTimeRange(min minDate:Date, max maxDate:Date)
    func getViewModel() -> ParkinglotDetailEditTimeViewModel?
    func setDetailViewModel(_ viewModel:ParkinglotDetailViewModelType)
    
   // func setOrderForm(type:ProductType, productId:Int, time:DateDuration?, quantity:Int)
}

class ParkinglotDetailEditScheduleView: UIStackView, ParkinglotDetailEditScheduleViewType {
    @IBOutlet weak var changeScheduleView: UIView!
    @IBOutlet weak var scheduleChangeButtonView: ParkinglotDetailScheduleButtonView!
    
    @IBOutlet weak var editControlPanelView: UIStackView!
    @IBOutlet weak var timeEditPanelView: ParkinglotDetailTimeControlView!
    @IBOutlet weak var fixedEditPanelView: ParkinglotDetailFixedControlView!
    @IBOutlet weak var monthlyEditPanelView: ParkinglotDetailMonthlyControlView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var expectedMonthlyDuration:BehaviorRelay<MonthlyDuration?> = BehaviorRelay(value: nil)
    var expectedTimeDuration:BehaviorRelay<DateDuration?> = BehaviorRelay(value: nil)
        
    var localizer:LocalizerType = Localizer.shared
    
    var viewModel: ParkinglotDetailEditTimeViewModelType = ParkinglotDetailEditTimeViewModel()
    var detailViewModel: ParkinglotDetailViewModelType?
    
    let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    func setupTitleBinding() {
        viewModel.changeButtonTitleText
            .asDriver()
            .drive(scheduleChangeButtonView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.viewTitleText
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setupEditPanelBinding() {
        if let viewModel = detailViewModel {
            viewModel.getSelectedProductType()
                .filter { $0 != nil}
                .map { $0! }
                .subscribe(onNext: { [unowned self] type in
                    self.setSwitchEditPanel(with: type)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func setupButtonBinding() {
        scheduleChangeButtonView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.setEditingMode(true)
            }
            .disposed(by: disposeBag)
    }
    
    func setupTimeEditBidning() {
        viewModel.viewTitleText
            .asDriver()
            .drive(timeEditPanelView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.startDateFieldText
            .asDriver()
            .drive(timeEditPanelView.startDateFieldLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.startTimeFieldText
            .asDriver()
            .drive(timeEditPanelView.startTimeFieldLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.endDateFieldText
            .asDriver()
            .drive(timeEditPanelView.endDateFieldLabel.rx.text)
            .disposed(by: disposeBag)
               
        viewModel.endTimeFieldText
            .asDriver()
            .drive(timeEditPanelView.endTimeFieldLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.closeText
            .asDriver()
            .drive(timeEditPanelView.closeButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.applyText
            .asDriver()
            .drive(timeEditPanelView.applyButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.getExpectedTime()
            .asObservable()
            .subscribe(onNext: { [unowned self] duration in
                self.timeEditPanelView.setTimeRange(from: duration.start, to: duration.end)
            })
            .disposed(by: disposeBag)
        
        timeEditPanelView.getExpectedTimeRange()
            .asObservable()
            .subscribe(onNext: { [unowned self] duration in
                debugPrint("[START]", duration.start.toString() , " [END] ", duration.end.toString())
            })
            .disposed(by: disposeBag)
        
        timeEditPanelView.closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                 self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
        
        timeEditPanelView.getSelectedRange()
            .asObservable()
            .subscribe(onNext: { [unowned self] duration in
                debugPrint("[TIME][RESERVE][START]", duration.start.toString() , " [END] ", duration.end.toString())
                self.setExpectedProduct(type: .time, time: duration)
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
    }
    
    func setupFixedEditBidning() {
        viewModel.viewTitleText
            .asDriver()
            .drive(fixedEditPanelView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.closeText
            .asDriver()
            .drive(fixedEditPanelView.closeButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.applyText
            .asDriver()
            .drive(fixedEditPanelView.applyButton.rx.title())
            .disposed(by: disposeBag)
        
        fixedEditPanelView.closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
        
        fixedEditPanelView.applyButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    
    func setupMonthlyEditBidning() {
        viewModel.viewTitleText
             .asDriver()
             .drive(monthlyEditPanelView.titleLabel.rx.text)
             .disposed(by: disposeBag)
        
        viewModel.startDateFieldText
            .asDriver()
            .drive(monthlyEditPanelView.startDateFieldLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.periodOfUseFieldText
            .asDriver()
            .drive(monthlyEditPanelView.periodOfMonthFieldLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.closeText
            .asDriver()
            .drive(monthlyEditPanelView.closeButton.rx.title())
            .disposed(by: disposeBag)
            
        viewModel.applyText
            .asDriver()
            .drive(monthlyEditPanelView.applyButton.rx.title())
            .disposed(by: disposeBag)
    
        viewModel.getExpectedTime()
            .asObservable()
            .subscribe(onNext: { [unowned self] duration in
                self.monthlyEditPanelView.setPeriod(from: duration.start)
            })
            .disposed(by: disposeBag)
        
        monthlyEditPanelView.closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
        
        monthlyEditPanelView.getSelectedRange()
            .asObservable()
            .subscribe(onNext: { [unowned self] duration in
                debugPrint("[MONTHLY][RESERVE][START]", duration.start.toString() , " [END] ", duration.end.toString())
                self.setExpectedProduct(type: .monthly, time: duration)
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
        
        monthlyEditPanelView.getExpectedDateRange()
            .asObservable()
            .subscribe(onNext: { [unowned self] duration in
                
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Panel Show/Hide
    
    func setEditingMode(_ editing:Bool, animated:Bool = true) {
        changeScheduleView.isHidden = editing ? true : false
        
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .curveEaseInOut, animations: {
                self.editControlPanelView.isHidden = editing ? false : true
            })
        } else {
            self.editControlPanelView.isHidden = editing ? false : true
        }
    }
    
    func setSwitchEditPanel(with productType:ProductType?) {
        if let type = productType {
            timeEditPanelView.isHidden = (type == .time) ? false : true
            fixedEditPanelView.isHidden = (type == .fixed) ? false : true
            monthlyEditPanelView.isHidden = (type == .monthly) ? false : true
            
            setHidden(false)
        } else {
            setHidden(false)
        }
    }
    
    // MARK: - Local Methods
    
    func setHidden(_ flag:Bool) {
        if self.isHidden != flag {
            self.isHidden = flag
            self.changeScheduleView.isHidden  = flag
        }
    }
    
    func setExpectedProduct(type:ProductType, productId:Int = 0, time:DateDuration? = nil, monthly:MonthlyDuration? = nil, quantity:Int = 1) {
        if let viewModel = detailViewModel, let parkinglot = viewModel.parkinglotInfo.value {
            viewModel.setExpectedProduct(type: type, parkinglotId: parkinglot.id, productId: productId, time: time, monthly: monthly, quantity: quantity, updateSetting: false)
        }
    }
    
    // MARK: - Public Methods
    /*
    public func setTimeRange(min minDate:Date, max maxDate:Date) {
        //timeEditPanelView.setTimeTicketRange(min: minDate, max: maxDate)
    }
    */
    // MARK: - Setup Product Item
    
    func setupFixedProductItems() {
        viewModel.getProduct(with: .fixed)
            .asObservable()
            .flatMap({
                Observable.from($0).enumerated()
            })
            .subscribe(onNext: { [unowned self] (index, item) in
                self.fixedEditPanelView.updateProductItemView(with: item.name, index: index)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize() {
        setupTitleBinding()
        setupEditPanelBinding()
        setupButtonBinding()
        setEditingMode(false, animated: false)
        setupFixedProductItems()
        setupTimeEditBidning()
        setupMonthlyEditBidning()
        setupFixedEditBidning()
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func draw(_ rect: CGRect) {
        initialize()
    }
}

// MARK: - View Model Setter / Getter

extension ParkinglotDetailEditScheduleView {
    public func getViewModel() -> ParkinglotDetailEditTimeViewModel? {
        return (viewModel as! ParkinglotDetailEditTimeViewModel)
    }
    
    public func setDetailViewModel(_ viewModel:ParkinglotDetailViewModelType) {
        detailViewModel = viewModel
        
        if let product = viewModel.getExpectedProductInfo() {
            // expectedTimeDuration.accept(product.time)
            self.viewModel.setExpectedTime(duration: product.time)
            expectedMonthlyDuration.accept(product.monthly)
        }
    }
}
