//
//  SearchOptionViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RangeSeekSlider
import BetterSegmentedControl

extension SearchOptionViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Search Option"
    }
}

class SearchOptionViewController: UIViewController {
    
    @IBOutlet weak var headearView: UIView!
    @IBOutlet weak var topRoundedTipView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceStartLabel: UILabel!
    @IBOutlet weak var priceEndLabel: UILabel!
    @IBOutlet weak var priceUnitLabel: UILabel!
    @IBOutlet weak var priceRangeSeekSlider: RangeSeekSlider!
    @IBOutlet weak var pricePerUnitLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var priceGuideLabel: UILabel!
    @IBOutlet weak var priceLowLabel: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    
    @IBOutlet weak var sortTypeLabel: UILabel!
    @IBOutlet weak var sortingSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var operationTypeLabel: UILabel!
    @IBOutlet weak var operationSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var parkinglotTypeLabel: UILabel!
    @IBOutlet weak var areaTypeLabel: UILabel!
    @IBOutlet weak var areaInOutSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var extraOptionLabel: UILabel!
    @IBOutlet weak var cctvButton: UIButton!
    @IBOutlet weak var iotSensorButton: UIButton!
    @IBOutlet weak var noMechanicalButton: UIButton!
    @IBOutlet weak var allDayButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var viewModel: SearchOptionViewModelType
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Binding
    
    private func navigationBinding() {
        viewModel.viewTitleText
                 .drive(titleLabel.rx.text)
                 .disposed(by: disposeBag)
        
        topRoundedTipView.rx
                .tapGesture()
                .subscribe { _ in
                    self.dismissModal()
                }
                .disposed(by: disposeBag)
        
        headearView.rx
                .swipeGesture(.down)
                .subscribe { _ in
                    self.dismissModal()
                }
                .disposed(by: disposeBag)
    }
    
    private func priceSectionBinding() {
        viewModel.priceStartText
            .asDriver()
            .drive(priceStartLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.priceEndText
            .asDriver()
            .drive(priceEndLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.priceUnitText
            .drive(priceUnitLabel.rx.text)
            .disposed(by: disposeBag)
                
        viewModel.pricePerHourText
            .drive(pricePerUnitLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.priceMinimumText
            .drive(priceLowLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.priceMaximumText
            .drive(priceMaxLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.priceGuideText
            .drive(priceGuideLabel.rx.text)
            .disposed(by: disposeBag)
        
        priceRangeSeekSlider.delegate = viewModel as? RangeSeekSliderDelegate
    }
    
    private func sortingSectionBinding() {
        viewModel.sortTypeText
                .drive(sortTypeLabel.rx.text)
                .disposed(by: disposeBag)
        
        _ = Observable.from(optional: self.viewModel.sortSegmentedItems)
                .map { $0.map { return $0.title }}
                .subscribe(onNext: { items in
                    self.updateSegmentedControl(items, segmentedControl:self.sortingSegmentedControl)
                })
                .disposed(by: disposeBag)
        
        sortingSegmentedControl.rx.selected
            .asDriver()
            .map { index in
                return self.viewModel.sortSegmentedItems[index].type
            }
            .drive(self.viewModel.selectedSortType)
            .disposed(by: disposeBag)

    }
    
    private func operationTypeSectionBinding() {
        viewModel.operationTypeText
            .drive(parkinglotTypeLabel.rx.text)
            .disposed(by: disposeBag)

        _ = Observable.from(optional: self.viewModel.operationSegmentedItems)
                  .map { $0.map { return $0.title }}
                  .subscribe(onNext: { items in
                      self.updateSegmentedControl(items, segmentedControl:self.operationSegmentedControl)
                  })
                  .disposed(by: disposeBag)
          
          operationSegmentedControl.rx.selected
              .asDriver()
              .map { index in
                  return self.viewModel.operationSegmentedItems[index].type
              }
              .drive(self.viewModel.selectedOperationType)
              .disposed(by: disposeBag)
    }
    
    private func areaTypeSectionBinding() {
        viewModel.areaTypeText
            .drive(areaTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        _ = Observable.from(optional: self.viewModel.areaInOutSegmentedItems)
                .map { $0.map { return $0.title }}
                .subscribe(onNext: { items in
                    self.updateSegmentedControl(items, segmentedControl:self.areaInOutSegmentedControl)
                })
                .disposed(by: disposeBag)
        
        areaInOutSegmentedControl.rx.selected
            .asDriver()
            .map { index in
                return self.viewModel.areaInOutSegmentedItems[index].type
            }
            .drive(self.viewModel.selectedInOutType)
            .disposed(by: disposeBag)
    }
    
    private func optionTypeBinding() {
        viewModel.optionItemCCTV
            .drive(cctvButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.optionItemIotSensor
            .drive(iotSensorButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.optionItemNoMechanical
            .drive(noMechanicalButton.rx.title())
            .disposed(by: disposeBag)
           
        viewModel.optionItemFullTime
            .drive(allDayButton.rx.title())
            .disposed(by: disposeBag)
        
        cctvButton.rx.tap
            .asObservable()
            .map { (_) -> Bool in
                return !self.cctvButton.isSelected
            }
            .do(onNext: { (isSelected) in
                self.cctvButton.isSelected = isSelected
                self.viewModel.setItemCCTV(isSelected)
            })
            .bind(to: viewModel.isItemCCTV)
            .disposed(by: disposeBag)
        
        iotSensorButton.rx.tap
            .asObservable()
            .map { (_) -> Bool in
                return !self.iotSensorButton.isSelected
            }
            .do(onNext: { (isSelected) in
                self.iotSensorButton.isSelected = isSelected
                self.viewModel.setItemIotSensor(isSelected)
            })
            .bind(to: viewModel.isItemIotSensor)
            .disposed(by: disposeBag)
        
        noMechanicalButton.rx.tap
            .asObservable()
            .map { (_) -> Bool in
                return !self.noMechanicalButton.isSelected
            }
            .do(onNext: { (isSelected) in
                self.noMechanicalButton.isSelected = isSelected
                self.viewModel.setItemMechanical(isSelected)
            })
            .bind(to: viewModel.isItemMechanical)
            .disposed(by: disposeBag)
        
        allDayButton.rx.tap
            .asObservable()
            .map { (_) -> Bool in
                return !self.allDayButton.isSelected
            }
            .do(onNext: { (isSelected) in
                self.allDayButton.isSelected = isSelected
                self.viewModel.setItemFullTime(isSelected)
            })
            .bind(to: viewModel.isItemFullTime)
            .disposed(by: disposeBag)
    }
    
    
    private func buttonBinding() {
        viewModel.resetText
            .drive(resetButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.saveText
            .drive(saveButton.rx.title())
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .subscribe({ _ in
                self.viewModel.reset()
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe({ _ in
                self.dismissModal() {
                    self.viewModel.save()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup SegmentedControl
    
    private func updateSegmentedControl(_ items:[String], segmentedControl:BetterSegmentedControl) {
        _ = segmentedControl.options = [.backgroundColor(UIColor.white),
                                        .cornerRadius(0.0),
                                        .indicatorViewBackgroundColor(Color.shamrockGreen),
                                        .indicatorViewBorderColor(Color.shamrockGreen),
                                        .indicatorViewBorderWidth(0.6),
                                        .indicatorViewInset(0.0),
                                        .animationSpringDamping(1.0),
                                        .panningDisabled(true)]
        
        _ = segmentedControl.segments = LabelSegment.segments(withTitles: items,
                                    normalFont: Font.gothicNeoMedium16,
                                    normalTextColor: Color.slateGrey,
                                    selectedFont: Font.gothicNeoBold16,
                                    selectedTextColor: UIColor.white)
    }
    
    
    // MARK: - Local Methods
    
    // MARK: - Initialize

    init() {
        self.viewModel =  SearchOptionViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel =  SearchOptionViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        navigationBinding()
        priceSectionBinding()
        sortingSectionBinding()
        operationTypeSectionBinding()
        areaTypeSectionBinding()
        optionTypeBinding()
        buttonBinding()
        
        setupInitialValue()
    }
    
    
    private func setupInitialValue() {
        if let property = viewModel.getStoredValue() {
            self.priceRangeSeekSlider.selectedMinValue = property.from.toCGFloat
            self.priceRangeSeekSlider.selectedMaxValue = property.to.toCGFloat
            self.sortingSegmentedControl.setIndex(viewModel.sortSegmentedItems.firstIndex(where: { $0.type == property.sortType })!)
            self.operationSegmentedControl.setIndex(viewModel.operationSegmentedItems.firstIndex(where: { $0.type == property.lotType })!)
            self.areaInOutSegmentedControl.setIndex(viewModel.areaInOutSegmentedItems.firstIndex(where: { $0.type == property.inOutType })!)
            self.cctvButton.isSelected = property.isCCTV
            self.iotSensorButton.isSelected = property.isIotSensor
            self.noMechanicalButton.isSelected = property.isNoMechanical
            self.allDayButton.isSelected = property.isAllDay
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
