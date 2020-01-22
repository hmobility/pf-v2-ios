//
//  ParkinglotDetailReserveView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import Charts

class ParkinglotDetailReserveView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var availableParkinglotLabel: UILabel!
    
    @IBOutlet var chartView: HorizontalBarChartView!
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    
    // MARK: - Initializer

    private func initialize() {
        setupBinding()
        setupButtonBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        localizer.localized("ttl_detail_real_time_reserve_state")
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        localizer.localized("txt_detail_real_time_available_lots")
            .asDriver()
            .drive(self.availableParkinglotLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        infoButton.rx.tap
            .subscribe(onNext: { [unowned self] status in
                self.navigateToGuide()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    private func updateChartData() {
        let barWidth = 40.0
        let spaceForBar = 0
        
        chartView.cornerRadius = 20
        chartView.maxVisibleCount = 0
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .top
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 1
        
        chartView.rightAxis.enabled = false
        
        let legend = chartView.legend
        
        let count = 1
        let range:UInt32 = 24
        
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult:UInt32 =  1 + range
            let val1 = Double(arc4random_uniform(mult) + mult / 3)
            let val2 = Double(arc4random_uniform(mult) + mult / 3)
            let val3 = Double(arc4random_uniform(mult) + mult / 3)
            
            return BarChartDataEntry(x: Double(i), yValues: [val1, val2, val3], icon: nil)
        }
        
        let set1 = BarChartDataSet(entries: yVals, label: nil)
        set1.colors = ChartColorTemplates.material()
        set1.drawIconsEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth
        
        chartView.data = data
        
        
        chartView.animate(yAxisDuration: 0)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

    override func draw(_ rect: CGRect) {
        updateChartData()
    }
    
    // MARK: - Navigation
    
    private func navigateToGuide() {
        let target = Storyboard.detail.instantiateViewController(withIdentifier: "TimeLabelGuideViewController") as! TimeLabelGuideViewController
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .forever
        config.presentationStyle = .center
        config.preferredStatusBarStyle = .lightContent
   
        SwiftMessages.show(config: config, view: target.view)
    }
}
