//
//  ParkinglotDetailEditTimeView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailEditTimeView: UIStackView {
    
    @IBOutlet weak var changeTimeView: UIView!
    @IBOutlet weak var changeButtonView: ParkinglotDetailTimeButtonView!
    
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
            .drive(changeButtonView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.viewTitleText
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupEditPanelBinding() {
        if let viewModel = detailViewModel, let selectedProductType = viewModel.getSelectedProductType() {
            selectedProductType
                .subscribe(onNext: { [unowned self] productType in
                    self.setSwitchEditPanel(with: productType)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setupButtonBinding() {
        changeButtonView.rx
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
       self.changeTimeView.isHidden = editing ? true : false
        
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .curveEaseInOut, animations: {
                self.editControlPanelView.isHidden = editing ? false : true
            })
        } else {
            self.editControlPanelView.isHidden = editing ? false : true
        }
    }
    
    private func setSwitchEditPanel(with productType:ProductType) {
        timeEditPanelView.isHidden = (productType == .time) ? false : true
        fixedEditPanelView.isHidden = (productType == .fixed) ? false : true
        monthlyEditPanelView.isHidden = (productType == .monthly) ? false : true
    }
    
    // MARK: - Local Methods
    
    // MARK: - Public Methods
    
    // MARK: - Setup View Model
    
    private func setupFixedItems() {
        viewModel.getProduct(with: .fixed)
            .flatMap({
                Observable.from($0)
            })
            .subscribe(onNext: { [unowned self] item in
                self.fixedEditPanelView.updateTimeCheckItemView(with: item.name)
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
        setupFixedItems()
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
