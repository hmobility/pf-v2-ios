//
//  MainViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap
import PullUpController

extension MapViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] MainMap"
    }
}

class MapViewController: UIViewController {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchOptionButton: UIButton!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var placeCenterButton: UIButton!
    
    @IBOutlet weak var navigationMenuView: NavigationDialogView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var timeSelView: CustomTimeSelectionView!
    @IBOutlet weak var timeSettingView: UIView!
    
    @IBOutlet weak var mapView:NMFMapView!
    
    let location = CLLocationManager()
    
    var disposeBag = DisposeBag()
    
    private lazy var viewModel: MapViewModelType = MapViewModel(view: mapView)
    private var cardViewModel:ParkinglotCardViewModelType?
    
    private lazy var titleView = NavigationTitleView()
    
    // MARK: - Initialize
     
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        // setupMapBindings()
        setupNavigation()
        setupNavigationBinding()
        setupButtonBinding()
        timeSettingAreaBinding()
    }
    
    // MARK: - Bindings
    
    private func setupNavigation() {
        navigationItem.titleView = titleView
        
        titleView.titleColor = Color.darkGrey
        titleView.titleFont = Font.gothicNeoMedium26
        titleView.subTitleColor = Color.darkGrey
        titleView.subTitleFont = Font.helvetica12
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.isHidden = true
        }
    }
    
    private func setupNavigationBinding() {
        navigationMenuView.searchOptionButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToSearchOption()
            })
            .disposed(by: disposeBag)
        
        searchOptionButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToSearchOption()
            })
            .disposed(by: disposeBag)
        
        viewModel.displayAddressText.asDriver()
            .drive(navigationMenuView.mainTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        zoomInButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.zoomIn()
            })
            .disposed(by: disposeBag)
                
        zoomOutButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.zoomOut()
            })
            .disposed(by: disposeBag)
        
        placeCenterButton.rx.tap
            .bind { _ in 
                self.viewModel.placeCenter()
            }
            .disposed(by: disposeBag)
    }
    
    private func timeSettingAreaBinding() {
        viewModel.displaySettingView.asDriver()
            .drive(onNext: { (time, card) in
                self.cardView.isHidden = card ? false : true
                self.timeSettingView.isHidden = time ? false : true
            })
            .disposed(by: disposeBag)
        
        timeSelView.tapSearchArea()
            .subscribe { _ in
                
            }
            .disposed(by: disposeBag)
            
        timeSelView.tapSelectTime()
            .subscribe { _ in
                    
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupParkingLot()
        viewModel.placeCenter()
        
      //  print("[START]", Date().dateFor(.nearestHour(hour:1)).toString(format: .custom("HHmm")))
        print("[START]", Date().dateFor(.nearestMinute(minute:60)).toString(format: .custom("HHmm")))
        print("[END]", Date().dateFor(.nearestMinute(minute:60)).adjust(.hour, offset: 2).toString(format: .custom("HHmm")))
        titleView.set(title: "TTT", subTitle: "SSSs")

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    func setupParkingLot() {
        let target = Storyboard.main.instantiateViewController(withIdentifier: "ParkinglotListViewController") as! ParkinglotTapViewController
         _ = target.view
        
        addPullUpController(target, initialStickyPointOffset: 100, animated: false)
    }
    
    func navigateToSearchOption() {
        let target = Storyboard.main.instantiateViewController(withIdentifier: "SearchOptionViewController") as! SearchOptionViewController
        self.modal(target, transparent: true)
    }
    
    func navigateToEvents() {
        let target = Storyboard.main.instantiateViewController(withIdentifier: "EventViewController") as! SearchOptionViewController
        self.modal(target, transparent: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParkinglotCardView" {
            if let destination = segue.destination as? ParkinglotCardViewController {
                self.viewModel.cardViewModel = destination.getCardViewModel()
            }
        }
    }
}
