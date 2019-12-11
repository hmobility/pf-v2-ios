//
//  SearchOptionViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/04.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import PullUpController
import RangeSeekSlider

extension SearchOptionViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Search Option"
    }
}

class SearchOptionViewController: PullUpController {
    
    @IBOutlet weak var headearView: UIView!
    @IBOutlet weak var topRoundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pricePerUnitLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var priceRangeSeekSlider: RangeSeekSlider!
    @IBOutlet weak var priceGuideLabel: UILabel!
    @IBOutlet weak var priceLowLabel: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    @IBOutlet weak var sortTypeLabel: UILabel!
    @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var parkinglotTypeLabel: UILabel!
    @IBOutlet weak var parkinglotSegmentedControl: UISegmentedControl!
    @IBOutlet weak var areaTypeLabel: UILabel!
    @IBOutlet weak var areaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var extraOptionLabel: UILabel!
    @IBOutlet weak var cctvButton: UIButton!
    @IBOutlet weak var iotSensorButton: UIButton!
    @IBOutlet weak var mechanicalButton: UIButton!
    @IBOutlet weak var fulltimeButton: UIButton!
    
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
        parkinglotTypeSectionBinding()
        buttonBinding()
    }
    
    // MARK: - Binding
    
    private func navigationBinding() {
        viewModel.viewTitleText
                 .drive(titleLabel.rx.text)
                 .disposed(by: disposeBag)
        
        topRoundedView.rx
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
        viewModel.pricePerHourText
                 .drive(pricePerUnitLabel.rx.text)
                 .disposed(by: disposeBag)
        
        viewModel.priceRangeText
                .drive(priceRangeLabel.rx.text)
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
/*
        viewModel.selectedMinimumPrice
                .asDriver()
                .map({ value in
                    return CGFloat(value)
                })
                .drive(onNext: { value in
                    self.priceRangeSeekSlider.selectedMinValue = value
                })
                .disposed(by: disposeBag)
        
        viewModel.selectedMaximumPrice
                .asDriver()
                .map({ value in
                    return CGFloat(value)
                 })
                .drive(onNext: { value in
                    self.priceRangeSeekSlider.selectedMaxValue = value
                })
                .disposed(by: disposeBag)
 */
    }
    
    private func sortingSectionBinding() {
        viewModel.sortTypeText
                .drive(sortTypeLabel.rx.text)
                .disposed(by: disposeBag)

        viewModel.sortItemLowPrice
                .drive(sortingSegmentedControl.rx.titleForSegment(at: 0))
                .disposed(by: disposeBag)
        
        viewModel.sortItemNearby
                .drive(sortingSegmentedControl.rx.titleForSegment(at: 1))
                .disposed(by: disposeBag)
   /*
        viewModel.selectedSortType
                .asDriver()
                .map({ type in
                    return type.rawValue
                })
                .drive(sortingSegmentedControl.rx.selectedSegmentIndex)
                .disposed(by: disposeBag)
     */
        sortingSegmentedControl.rx.selectedSegmentIndex
                .map { value in
                    return FilterSortType(rawValue: value)!
                }
                .bind(to: self.viewModel.selectedSortType)
                .disposed(by: disposeBag)
    }
    
    
    private func parkinglotTypeSectionBinding() {
        viewModel.parkingLotTypeText
            .drive(parkinglotTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.parkingLotItemNone
            .drive(parkinglotSegmentedControl.rx.titleForSegment(at: 0))
            .disposed(by: disposeBag)
        
        viewModel.parkingLotItemPublic
            .drive(parkinglotSegmentedControl.rx.titleForSegment(at: 1))
            .disposed(by: disposeBag)
        
        viewModel.parkingLotItemPrivate
            .drive(parkinglotSegmentedControl.rx.titleForSegment(at: 2))
            .disposed(by: disposeBag)
        
        parkinglotSegmentedControl.rx.selectedSegmentIndex
            .map { value in
                return FilterOperationType(rawValue: value)!
            }
            .bind(to: self.viewModel.selectedParkingLotType)
            .disposed(by: disposeBag)
        
        /*
        viewModel.selectedParkingLotType
            .asDriver()
            .map({ type in
                return type.rawValue
            })
            .drive(parkinglotSegmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
         */
    }
    
    private func areaTypeSectionBinding() {
        viewModel.parkingLotTypeText
            .drive(areaTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.parkingLotItemNone
            .drive(areaSegmentedControl.rx.titleForSegment(at: 0))
            .disposed(by: disposeBag)
        
        viewModel.parkingLotItemPublic
            .drive(areaSegmentedControl.rx.titleForSegment(at: 1))
            .disposed(by: disposeBag)
        
        viewModel.parkingLotItemPrivate
            .drive(areaSegmentedControl.rx.titleForSegment(at: 2))
            .disposed(by: disposeBag)
        
        viewModel.selectedAreaType
            .asDriver()
            .map({ type in
                return type.rawValue
            })
            .drive(areaSegmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        areaSegmentedControl.rx.selectedSegmentIndex
            .map { value in
                return FilterAreaType(rawValue: value)!
            }
            .bind(to: self.viewModel.selectedAreaType)
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
                self.viewModel.save()
            })
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
        
        mechanicalButton.rx.tap
            .asObservable()
            .map { (_) -> Bool in
                return !self.mechanicalButton.isSelected
            }
            .do(onNext: { (isSelected) in
                self.mechanicalButton.isSelected = isSelected
                self.viewModel.isItemMechanical.accept(isSelected)
            })
            .bind(to: viewModel.isItemMechanical)
            .disposed(by: disposeBag)
        
        fulltimeButton.rx.tap
            .asObservable()
            .map { (_) -> Bool in
                return !self.fulltimeButton.isSelected
            }
            .do(onNext: { (isSelected) in
                self.fulltimeButton.isSelected = isSelected
                self.viewModel.isItemFullTime.accept(isSelected)
            })
            .bind(to: viewModel.isItemFullTime)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    
    private func resetAll() {
        priceRangeSeekSlider.selectedMinValue = priceRangeSeekSlider.minValue
        priceRangeSeekSlider.selectedMaxValue = priceRangeSeekSlider.maxValue
        
        sortingSegmentedControl.selectedSegmentIndex = 0
        parkinglotSegmentedControl.selectedSegmentIndex = 0
        areaSegmentedControl.selectedSegmentIndex = 0
        
        cctvButton.isSelected = false
        iotSensorButton.isSelected = false
        mechanicalButton.isSelected = false
        fulltimeButton.isSelected = false
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
