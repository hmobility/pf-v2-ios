//
//  MainViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap
import FloatingPanel
import SideMenu

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
    
    @IBOutlet weak var parkingInfoView: UIView!
    @IBOutlet weak var parkingInfoBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var cardSectionView: UIView!
    @IBOutlet weak var searchSectionView: UIView!
    
    @IBOutlet weak var timeSettingView: CustomTimeSettingView!
    
    @IBOutlet weak var mapView:NMFMapView!
    @IBOutlet private weak var rootView: UIView!
    
    let location = CLLocationManager()
    
    var disposeBag = DisposeBag()
    
    private lazy var viewModel: MapViewModelType = MapViewModel(view: mapView)
    private var cardViewModel:ParkingCardViewModelType?
    
    private lazy var titleView = NavigationTitleView()
    
    fileprivate var floatingPanelController: FloatingPanelController!
    
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
        
        navigationMenuView.menuButton.rx.tap
            .subscribe(onNext: { _ in
                self.showSideMenu()
            })
            .disposed(by: disposeBag)
        
        searchOptionButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigateToSearchOption()
            })
            .disposed(by: disposeBag)
        
        viewModel.displayAddressText
            .asDriver()
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
        viewModel.displaySettingSection
            .asDriver()
            .drive(onNext: { (search, list) in
                self.cardContainerView.isHidden = search ? true : false
                //self.cardSectionView.isHidden = search ? true : false
                self.searchSectionView.isHidden = search ? false : true
            })
            .disposed(by: disposeBag)
        
        timeSettingView.tapSearchArea()
            .subscribe { _ in
                
            }
            .disposed(by: disposeBag)
            
        timeSettingView.tapSelectTime()
            .subscribe { _ in
                self.navigateToTimeDialog()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        prepareFloatingPanel()
        
        timeSettingAreaBinding()
        setupNavigation()
        setupNavigationBinding()
        setupButtonBinding()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
      //  setupParkingLot()
        viewModel.placeCenter()
        
      //  print("[START]", Date().dateFor(.nearestHour(hour:1)).toString(format: .custom("HHmm")))
        print("[START]", Date().dateFor(.nearestMinute(minute:60)).toString(format: .custom("HHmm")))
        print("[END]", Date().dateFor(.nearestMinute(minute:60)).adjust(.hour, offset: 2).toString(format: .custom("HHmm")))
        titleView.set(title: "TTT", subTitle: "SSSs")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        floatingPanelController.addPanel(toParent: self, animated: false)
    }
    
    // MARK: - Navigation

    func navigateToSearchOption() {
        let target = Storyboard.main.instantiateViewController(withIdentifier: "SearchOptionViewController") as! SearchOptionViewController
        self.modal(target, transparent: true)
    }
    
    func navigateToEvents() {
        let target = Storyboard.main.instantiateViewController(withIdentifier: "EventViewController") as! SearchOptionViewController
        self.modal(target, transparent: true)
    }
    
    func navigateToTimeDialog() {
        TimeTicketDialog.show(source: self)
    }
    
    func showSideMenu() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    
        let presentationStyle:SideMenuPresentationStyle = .menuSlideIn
        presentationStyle.backgroundColor = Color.darkGrey3
        presentationStyle.presentingEndAlpha = 0.6
    
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.statusBarEndAlpha = 0
        settings.menuWidth = view.frame.width
        settings.allowPushOfSameClassTwice = false
        settings.dismissOnPresent = false
   
        let menu = SideMenuNavigationController(rootViewController: target)
        menu.leftSide = true
        menu.settings = settings
        menu.isNavigationBarHidden = true
        
        present(menu, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParkingCardView" {
            if let destination = segue.destination as? ParkinglotCardViewController {
                self.viewModel.cardViewModel = destination.getViewModel()
            }
        }
    }
}

// MARK: - FloatingPanelControllerDelegate

extension MapViewController: FloatingPanelControllerDelegate {
    func prepareFloatingPanel() {
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.backgroundColor = .clear

        let target = Storyboard.main.instantiateViewController(withIdentifier: "ParkingTapViewController") as! ParkingTapViewController
        
        self.viewModel.parkingTapViewModel = target.getViewModel()
       
        floatingPanelController.set(contentViewController: target)
    }
    
    //MARK: - FloatingPanelControllerDelegate
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return BottomFloatingLayout(bottomInset: self.parkingInfoBottomConstraint.constant)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return BottomFloatingPanelBehavior()
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
    }
}

// MARK: - SideMenuNavigationControllerDelegate

extension MapViewController: SideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
         debugPrint("SideMenu Appearing! (animated: \(animated))")
     }
     
     func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
         debugPrint("SideMenu Appeared! (animated: \(animated))")
     }
     
     func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
         debugPrint("SideMenu Disappearing! (animated: \(animated))")
     }
     
     func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
         debugPrint("SideMenu Disappeared! (animated: \(animated))")
     }
}
