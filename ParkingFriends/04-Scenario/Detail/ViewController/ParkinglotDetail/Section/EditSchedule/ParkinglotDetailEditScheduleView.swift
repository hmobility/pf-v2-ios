//
//  ParkinglotDetailEditTimeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailEditScheduleView: UIStackView {
    @IBOutlet weak var changeScheduleView: UIView!
    @IBOutlet weak var scheduleChangeButtonView: ParkinglotDetailScheduleButtonView!
    
    @IBOutlet weak var editControlPanelView: UIStackView!
    @IBOutlet weak var timeEditPanelView: ParkinglotDetailTimeControlView!
    @IBOutlet weak var fixedEditPanelView: ParkinglotDetailFixedControlView!
    @IBOutlet weak var monthlyEditPanelView: ParkinglotDetailMonthlyControlView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    private var viewModel: ParkinglotDetailEditTimeViewModelType = ParkinglotDetailEditTimeViewModel()
    private var detailViewModel: ParkinglotDetailViewModelType?
    
    // MARK: - Binding
    
    private func setupTitleBinding() {
        viewModel.changeButtonTitleText
            .asDriver()
            .drive(scheduleChangeButtonView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.viewTitleText
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupEditPanelBinding() {
        if let viewModel = detailViewModel {
            viewModel.getSelectedProductType()
                .subscribe(onNext: { [unowned self] productType in
                    self.setSwitchEditPanel(with: productType)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setupButtonBinding() {
        scheduleChangeButtonView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.setEditingMode(true)
            }
            .disposed(by: disposeBag)
    
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
        
        applyButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.setEditingMode(false)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Panel Show/Hide
    
    private func setEditingMode(_ editing:Bool, animated:Bool = true) {
        changeScheduleView.isHidden = editing ? true : false
        
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .curveEaseInOut, animations: {
                self.editControlPanelView.isHidden = editing ? false : true
            })
        } else {
            self.editControlPanelView.isHidden = editing ? false : true
        }
    }
    
    private func setSwitchEditPanel(with productType:ProductType?) {
        if let type =  productType {
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
    
    // MARK: - Public Methods
    
    // MARK: - Setup View Model
    
    private func setupFixedProductItems() {
        viewModel.getProduct(with: .fixed)
            .asObservable()
            .flatMap({
                Observable.from($0).enumerated()
            })
            .subscribe(onNext: { [unowned self] (index, item) in
                self.fixedEditPanelView.updateTimeCheckItemView(with: item.name, index: index)
            })
            .disposed(by: disposeBag)
    }
    
    public func getViewModel() -> ParkinglotDetailEditTimeViewModel? {
        return (viewModel as! ParkinglotDetailEditTimeViewModel)
    }
    
    public func setDetailViewModel(_ viewModel:ParkinglotDetailViewModelType) {
        detailViewModel = viewModel
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
        setupTitleBinding()
        setupEditPanelBinding()
        setupButtonBinding()
        setEditingMode(false, animated: false)
        setupFixedProductItems()
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        initialize()
    }
}
