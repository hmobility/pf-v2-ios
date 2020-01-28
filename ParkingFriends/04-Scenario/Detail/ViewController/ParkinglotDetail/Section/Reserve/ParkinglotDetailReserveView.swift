//
//  ParkinglotDetailReserveView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/21.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import AAInfographics

class ParkinglotDetailReserveView: UIStackView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var availableParkinglotLabel: UILabel!
    
    @IBOutlet var chartView: UIView!
    
    private var aaChartView:AAChartView?
    private var chartOptions:AAOptions?
    
    private lazy var viewModel: ParkinglotDetailReserveViewModelType = ParkinglotDetailReserveViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
        setupBinding()
        setupButtonBinding()
        
        setupChartView()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.viewTitleText
            .asDriver()
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.availableParkinglotText
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
    
    // MARK: - Public Methods
    
    public func getViewModel() -> ParkinglotDetailReserveViewModel? {
        return (viewModel as! ParkinglotDetailReserveViewModel) 
    }
    
    // MARK: - Local Methods
    
    // MARK: - Chart Update
    
    private func setupChartView() {
        aaChartView = AAChartView()
        let width = chartView.frame.size.width
        let height:CGFloat =  chartView.frame.size.height
        
        if let view = aaChartView {
            chartOptions = getChartOption()
            debugPrint("[CHART FRAME] width: ", width, " height : ", height)
            view.frame = CGRect(x: -8, y: -150, width: width, height: 300)
            view.contentWidth = width - ((width / 25) - 8)
            view.contentHeight = 300
            view.scrollEnabled = false
            
            chartView.addSubview(view)
        }
    }
    
    private func getChartOption() -> AAOptions {
        let aaChartModel = AAChartModel()
            .title("")
            .chartType(.columnrange)
            .animationDuration(0)
            .backgroundColor(Color.iceBlue.hexString)
            .yAxisMin(0)
            .yAxisMax(24)
            .yAxisTitle("")
            .marginBottom(0)
            .marginRight(0)
            .marginLeft(0)
            .inverted(true)
            .dataLabelsEnabled(false)
            .xAxisLabelsEnabled(false)
            .xAxisGridLineWidth(0)
            .yAxisGridLineWidth(0)
            .legendEnabled(false)
            .tooltipEnabled(false)
            .series([AASeriesElement()])
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel)
        
        return aaOptions
    }
    
    func getAvailableTimes(_ times:[OperationTime]) -> [AAPlotBandsElement]? {
        var plotBands:[AAPlotBandsElement] = []
        let availableTimeColor = Color.lightSeafoam.hexString
        
        for element in times {
            let item = getPlotBand(start:element.from.toDate, end:element.to.toDate, color:availableTimeColor)
            plotBands.append(item)
        }
        
        return plotBands.count > 0 ? plotBands : nil
    }
    
    func getPlotBand(start:Date?, end:Date?, color:String) -> AAPlotBandsElement {
        let start = Float(start?.hours ?? 0)
        let end = Float(end?.hours ?? 0)
        let bandColor = color
        
        let item = AAPlotBandsElement()
                      .from(start)
                      .to(end)
                      .color(bandColor)
        
        return item
    }
    
    private func updateAvailableTimeChart() {
        viewModel.availableTimeList
            .asObservable()
            .map({ times in
                return self.getAvailableTimes(times)
            })
            .subscribe(onNext:{ [unowned self] bands in
                if let times = bands, let view = self.aaChartView, let options = self.chartOptions {
                    options.yAxis?.plotBands(times)
                    view.aa_drawChartWithChartOptions(options)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateOnReserveTime() {
        let onReserveColor = Color.algaeGreen.hexString
        
        viewModel.onReserveTime
                .compactMap { $0 }
                .asObservable()
                .map({ duration in
                    return self.getPlotBand(start:duration.start, end:duration.end, color: onReserveColor)
                })
                .subscribe(onNext:{ [unowned self] bandElement in
                    if let view = self.aaChartView, let options = self.chartOptions {
                        options.yAxis?.plotBands?.append(bandElement)
                        view.aa_drawChartWithChartOptions(options)
                    }
                })
                .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

    override func draw(_ rect: CGRect) {
        updateAvailableTimeChart()
        updateOnReserveTime()
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
