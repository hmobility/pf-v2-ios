//
//  ParkinglotDetailViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/16.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import MXParallaxHeader

extension ParkinglotDetailViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Parkinglot Detail"
    }
}

class ParkinglotDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: MXScrollView!
    @IBOutlet var headerView:ParkinglotDetailHeaderView!
    @IBOutlet var symbolView:ParkinglotDetailSymbolView!
    @IBOutlet var priceView:ParkinglotDetailPriceInfoView!
    @IBOutlet var operationTimeView:ParkinglotDetailOperationTimeView!
    @IBOutlet var noticeView:ParkinglotDetailGuideView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    private var within:WithinElement?
    
    private lazy var viewModel: ParkinglotDetailViewModelType = ParkinglotDetailViewModel(within: within!)
    private lazy var titleView = NavigationTitleView()
    
    private let disposeBag = DisposeBag()

    // MARK: - Binding
    
    private func setupNavigationBinding() {
        navigationItem.titleView = titleView
        
        titleView.titleColor = UIColor.white
        titleView.titleFont = Font.gothicNeoSemiBold19
        titleView.subTitleColor = UIColor.white
        titleView.subTitleFont = Font.helvetica12
        
        viewModel.viewTitleText
            .drive(titleView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.viewSubtitleText
            .drive(titleView.subTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissRoot()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup Header
    
    private func setupHeaderView() {
        viewModel.imageList
            .asDriver()
            .drive(onNext: { images in
                self.headerView.setImageUrl(images)
            })
            .disposed(by: disposeBag)

        headerView.bookmarkAction = { flag in
            debugPrint("[HEADER] Tapped BOOKMARK")
        }
        
        headerView.navigationAction = { id in
            debugPrint("[HEADER] Tapped NAVIGATION")
        }
    }
    
    private func setupSymbolView() {
        viewModel.markSymbolList
            .asDriver()
            .drive(onNext: { symbols in
                self.symbolView.setSymbolList(symbols)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPriceView() {
        viewModel.detailInfo
            .asDriver()
            .drive(onNext: { info in
                if let item = info {
                    self.priceView.setSupported(item.supportItems, fee: item.baseFee)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupOperationTimeView() {
        viewModel.operationTimeList
            .asDriver()
            .drive(onNext: { operations in
                self.operationTimeView.setOperationTimeList(operations)
            })
            .disposed(by: disposeBag)
       }
    
    private func setupGuideView() {
        viewModel.noticeList
            .asDriver()
            .drive(onNext: { notices in
                
                let items = ["• 무인으로 운영되는 거주자우선주차구역입니다./n주차장 운영시간 및 예약시간을 준수해주세요.",
                "• 입차시 비어있는 주차면에 자유롭게 주차 가능합니다.",
                "• 최소 예약 가능시간은 1시간입니다.",
                "• 연장 결제는 30분 단위로 가능합니다."]
                 
                self.noticeView.setContents(items)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup ScrollView
    
    private func setupScrollView() {
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = 300
        scrollView.parallaxHeader.mode = .topFill
        scrollView.parallaxHeader.delegate = self
    }
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupNavigationBinding()
        setupButtonBinding()
        
        setupScrollView()
        setupHeaderView()
        setupSymbolView()
        setupPriceView()
        setupOperationTimeView()
        setupGuideView()
    }
        
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
        viewModel.loadDetailInfo()
    }
    
    // MARK: - Local Methods
    
    private func updateDetail(with element:Parkinglot) {
        let images = element.images
        headerView.setImageUrl(images)
    }
   
    // MARK: - Public Method
    
    public func setWithinElement(_ element:WithinElement) {
        within = element
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


// MARK: - Parallax header delegate
extension ParkinglotDetailViewController: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        NSLog("progress %f", parallaxHeader.progress)
    }
}
