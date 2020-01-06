//
//  SearchOptionViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RangeSeekSlider

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
    @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var operationTypeLabel: UILabel!
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var parkinglotTypeLabel: UILabel!
    @IBOutlet weak var areaTypeLabel: UILabel!
    @IBOutlet weak var areaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var extraOptionLabel: UILabel!
    @IBOutlet weak var cctvButton: UIButton!
    @IBOutlet weak var iotSensorButton: UIButton!
    @IBOutlet weak var noMechanicalButton: UIButton!
    @IBOutlet weak var allDayButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var viewModel: SearchOptionViewModelType
    private let disposeBag = DisposeBag()
    
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
        optionTypeBinding()
        buttonBinding()
        
        setupInitialValue()
    }
    
    private func setupInitialValue() {
        if let value = viewModel.getStoredValue() {
            self.priceRangeSeekSlider.selectedMinValue = value.from.toCGFloat
            self.priceRangeSeekSlider.selectedMaxValue = value.to.toCGFloat
            self.sortingSegmentedControl.selectedSegmentIndex = value.sortType.index
            self.operationSegmentedControl.selectedSegmentIndex = value.lotType.index
            self.areaSegmentedControl.selectedSegmentIndex = value.lotType.index
            self.cctvButton.isSelected = value.isCCTV
            self.iotSensorButton.isSelected = value.isIotSensor
            self.noMechanicalButton.isSelected = value.isNoMechanical
            self.allDayButton.isSelected = value.isAllDay
        }
    }
    
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
    /*
        viewModel.priceRangeText
            .drive(priceRangeLabel.rx.text)
            .disposed(by: disposeBag)
      */
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
        
      //  sortingSegmentedControl.removeAllSegments()
        
        for (index, item) in viewModel.sortSegmentedControl.enumerated() {
            debugPrint("[ITEM] - ", item.title)
            sortingSegmentedControl.setTitle(item.title, forSegmentAt: index)
        }
     /*
        viewModel.sortItemLowPrice
                .drive(sortingSegmentedControl.rx.titleForSegment(at: 0))
                .disposed(by: disposeBag)
        
        viewModel.sortItemNearby
                .drive(sortingSegmentedControl.rx.titleForSegment(at: 1))
                .disposed(by: disposeBag)
         */
        sortingSegmentedControl.rx.selectedSegmentIndex
            .asDriver()
            .map { index in
                return self.viewModel.sortSegmentedControl[index].type
            }
            .drive(self.viewModel.selectedSortType)
            .disposed(by: disposeBag)
    }
    
    private func operationTypeSectionBinding() {
        viewModel.operationTypeText
            .drive(parkinglotTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.operationItemNone
            .drive(operationSegmentedControl.rx.titleForSegment(at: 0))
            .disposed(by: disposeBag)
        
        viewModel.operationItemPublic
            .drive(operationSegmentedControl.rx.titleForSegment(at: 1))
            .disposed(by: disposeBag)
        
        viewModel.operationItemPrivate
            .drive(operationSegmentedControl.rx.titleForSegment(at: 2))
            .disposed(by: disposeBag)
        
        operationSegmentedControl.rx.selectedSegmentIndex
            .asDriver()
            .map { value in
                switch value {
                case 0:
                    return ParkingLotType.none
                case 1:
                    return ParkingLotType.public_lot
                case 2:
                    return ParkingLotType.private_lot
                default:
                    return ParkingLotType.none
                }
            }
            .drive(self.viewModel.selectedOperationType)
            .disposed(by: disposeBag)
    }
    
    private func areaTypeSectionBinding() {
        viewModel.operationTypeText
            .drive(areaTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.operationItemNone
            .drive(areaSegmentedControl.rx.titleForSegment(at: 0))
            .disposed(by: disposeBag)
        
        viewModel.operationItemPublic
            .drive(areaSegmentedControl.rx.titleForSegment(at: 1))
            .disposed(by: disposeBag)
        
        viewModel.operationItemPrivate
            .drive(areaSegmentedControl.rx.titleForSegment(at: 2))
            .disposed(by: disposeBag)
        /*
        viewModel.selectedAreaType
            .asDriver()
            .map({ type in
                return InOutDoorType(index: type)

            })
            .drive(areaSegmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        */
        areaSegmentedControl.rx.selectedSegmentIndex
            .asDriver()
            .map { value in
                switch value {
                case 0:
                    return InOutDoorType.none
                case 1:
                    return InOutDoorType.outdoor
                case 2:
                    return InOutDoorType.indoor
                default:
                    return InOutDoorType.none
                }

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
                self.viewModel.isItemCCTV.accept(isSelected)
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
                self.viewModel.isItemIotSensor.accept(isSelected)
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
                self.viewModel.isItemMechanical.accept(isSelected)
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
                self.viewModel.isItemFullTime.accept(isSelected)
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
            .do {
                self.viewModel.save()
            }
            .subscribe({ _ in
                self.dismissModal()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
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
