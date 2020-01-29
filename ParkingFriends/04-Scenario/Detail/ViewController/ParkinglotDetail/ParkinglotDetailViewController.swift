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
    @IBOutlet weak var headerView:ParkinglotDetailHeaderView!
    @IBOutlet weak var symbolView:ParkinglotDetailSymbolView!
    @IBOutlet weak var reserveStatusView: ParkinglotDetailReserveView!
    @IBOutlet weak var priceView:ParkinglotDetailPriceInfoView!
    @IBOutlet weak var operationTimeView:ParkinglotDetailOperationTimeView!
    @IBOutlet weak var noticeView:ParkinglotDetailNoticeView!
    
    @IBOutlet var navigationBar:TransparentNavigationBar!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    private var within:WithinElement?
    
    private lazy var viewModel: ParkinglotDetailViewModelType = ParkinglotDetailViewModel(within: within!)
    private lazy var titleView:NavigationTitleView = NavigationTitleView()
    
    private let disposeBag = DisposeBag()

    // MARK: - Binding
    
    private func setupNavigationBinding() {
        titleView = NavigationTitleView()
        
        self.navigationBar.topItem?.titleView = titleView
        
        titleView.titleColor = UIColor.white
        titleView.subtitleColor = UIColor.white
        titleView.titleFont = Font.gothicNeoSemiBold19
        titleView.subtitleFont = Font.helvetica12
      
        viewModel.viewTitleText
            .drive(self.titleView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.viewSubtitleText
            .drive(titleView.subtitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissRoot()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup View Model
    
    private func setupHeaderViewModel() {
        if let viewModel = headerView.getViewModel() {
            self.viewModel.setHeaderViewModel(viewModel)
            
            headerView.navigationAction = { flag in
            }
        }
    }
    
    private func setupParkingSymbolViewModel() {
        if let viewModel = symbolView.getViewModel() {
            self.viewModel.setSymbolViewModel(viewModel)
        }
    }
    
    private func setupPriceViewModel() {
        if let viewModel = priceView.getViewModel() {
            self.viewModel.setPriceViewModel(viewModel)
        }
    }
    
    private func setupOperationTimeViewModel() {
        if let viewModel = operationTimeView.getViewModel() {
            self.viewModel.setOperationTimeViewModel(viewModel)
        }
    }
    
    private func setupReserveSatusViewModel() {
        if let viewModel = reserveStatusView.getViewModel() {
            self.viewModel.setReserveViewModel(viewModel)
            
            reserveStatusView.infoGuideAction = {
                self.navigateToInfoGuide()
            }
        }
    }
    
    private func setupNoticeViewModel() {
        if let viewModel = noticeView.getViewModel() {
            self.viewModel.setNoticeViewModel(viewModel)
        }
    }
    
    // MARK: - Setup ScrollView
    
    private func setupScrollView() {
        let minY = navigationBar.frame.minY
        let maxY = navigationBar.frame.maxY
        let height = headerView.bounds.size.height
        
        debugPrint("[HEADER] height : ", height, " Min Y :" , minY)
     
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = (height + minY)
        scrollView.parallaxHeader.minimumHeight = maxY
        scrollView.parallaxHeader.mode = .topFill
        scrollView.parallaxHeader.delegate = headerView
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

        setupHeaderViewModel()
        setupParkingSymbolViewModel()
        setupPriceViewModel()
        setupOperationTimeViewModel()
        setupReserveSatusViewModel()
        setupNoticeViewModel()
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

     // MARK: - Navigation
     
     private func navigateToInfoGuide() {
         let target = Storyboard.detail.instantiateViewController(withIdentifier: "ParkinglotDetailTimeLabelGuideViewController") as! ParkinglotDetailTimeLabelGuideViewController
         
        self.modal(target, transparent:true, animated: false)
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
