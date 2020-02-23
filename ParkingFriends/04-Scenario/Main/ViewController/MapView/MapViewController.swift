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
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var placeCenterButton: UIButton!
    
    @IBOutlet weak var searchResultNavigationView: MapSearchResultNavigationView!
 
    @IBOutlet weak var navigationMenuView: NavigationDialogView!
    
    @IBOutlet weak var parkingInfoView: UIView!
    @IBOutlet weak var parkingInfoBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardContainerView: UIView!
  //  @IBOutlet weak var cardSectionView: UIView!
    @IBOutlet weak var searchSectionView: UIView!
    
    @IBOutlet weak var timeSettingView: CustomTimeSettingView!
    
    @IBOutlet weak var mapView:NMFMapView!
    
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var safeAreaView: UIView!
    
    let location = CLLocationManager()
    
    private lazy var viewModel: MapViewModelType = MapViewModel(view: mapView)
    private var cardViewModel:ParkingCardViewModelType?
    
    fileprivate var floatingPanelController: FloatingPanelController!
    fileprivate var cardViewController: ParkinglotCardViewController?
    
    let disposeBag = DisposeBag()
    
    // MARK: - Bindings
    
    private func setupNavigationBinding() {
        searchResultNavigationView.backButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.showNavigationBar(false)
                self.viewModel.removeSearchResultMark()
            })
            .disposed(by: disposeBag)
        
        searchResultNavigationView.optionButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.navigateToSearchOption()
            })
            .disposed(by: disposeBag)
        
        navigationMenuView.searchOptionButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.navigateToSearchOption()
            })
            .disposed(by: disposeBag)
        
        navigationMenuView.menuButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.showSideMenu()
            })
            .disposed(by: disposeBag)
        
        viewModel.displayAddressText
            .asDriver()
            .drive(onNext:{ [unowned self] text in
                self.searchResultNavigationView.setTitle(text)
                self.navigationMenuView.mainTitleButton.setTitle(text, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.displayBookingTimeText
            .asDriver()
            .drive(onNext:{ [unowned self] text in
                self.searchResultNavigationView.setSubtitle(text)
                self.navigationMenuView.setReservable(time: text)
                self.timeSettingView.setReservable(time: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchResultavigation() {
        showNavigationBar(false)
    }
    
    private func setupSearchBinding() {
        Observable.combineLatest(navigationMenuView.mainTitleButton.rx.tap,
                                 self.viewModel.userLocation())
                        .map { return $1 }
                        .subscribe(onNext: { [unowned self] coordinate in
                            debugPrint("[Search] text: \(coordinate)")
                            self.navigateToSearch(with: coordinate)
                           
                       })
                       .disposed(by: self.disposeBag)
        
        Observable.combineLatest(timeSettingView.tapSearchArea(),
                                 self.viewModel.userLocation())
                        .map { return $1 }
                        .subscribe(onNext: { [unowned self] coordinate in
                            self.navigateToSearch(with: coordinate)
                        })
                        .disposed(by: self.disposeBag)
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
    
    private func setupMapMarkerBinding() {
        viewModel.tappedMapMarker
            .asDriver()
            .filter { $0 != nil }
            .map { $0!}
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] element in
                self.navigateToDetail(with: element)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bottom Menu
    
    private func timeSettingAreaBinding() {
        viewModel.displaySettingSection
            .asDriver()
            .drive(onNext: { (list, search) in
                self.cardContainerView.isHidden = list ? false : true
                self.searchSectionView.isHidden = search ? false : true
            })
            .disposed(by: disposeBag)
            
        timeSettingView.tapSelectTime()
            .subscribe { _ in
                self.navigateToTimeDialog()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Card Event Handling
    
    private func handleCardEvents() {
        if let card = cardViewController {
            card.detailButtonAction = { [unowned self] element  in
                debugPrint("[CARD] - Detail, Handle events from cards")
                self.navigateToDetail(with: element)
            }
            
            card.reserveButtonAction = { [unowned self] element  in
                debugPrint("[CARD] - Rerverve, Handle events from cards")
                self.navigateToReserveTicket()
            }
            
            card.focusedItemAction = { [unowned self] (index, itemId) in
                debugPrint("[CARD] - Focused #", index, " #Id ", itemId)
                self.viewModel.setFocusedMarker(with: itemId)
            }
        }
    }
    
    // MARK: - Navigation Bar
    
    private func showNavigationBar(_ flag:Bool = false) {
        navigationMenuView.isHidden = flag ? true : false
        
        updateSearchResultOrder()
       
        if flag {
            searchResultNavigationView.show()
        } else {
            searchResultNavigationView.hide()
        }
 
        searchResultNavigationView.isHidden = flag ? false : true
    }
    
    private func updateSearchResultOrder() {
        if let viewModel = self.viewModel.parkingTapViewModel {
            viewModel.sortOrderText
                .asDriver()
                .drive(onNext: { [unowned self] text in
                    self.searchResultNavigationView.setSearchOrder(text)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Map
    
    private func setupMapViewPadding() {
        let topPadding = navigationMenuView.frame.maxY
        let bottomPadding = parkingInfoView.frame.maxY - parkingInfoView.frame.minY
     
        mapView.logoAlign = .leftBottom
        mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        mapView.contentInset = UIEdgeInsets(top: topPadding, left: 0, bottom: bottomPadding, right: 0)
    }
    
    // MARK: - Search Result

    private func updateSearchResult(with coord:CoordType) {
        debugPrint("[SEARCH][RESULT] - ", coord)
        self.viewModel.updateSearchResult(with: coord)
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
        setupSearchResultavigation()
        setupNavigationBinding()
        setupButtonBinding()
        setupSearchBinding()
        
       // setupMapViewPadding()
        
        setupMapMarkerBinding()

        handleCardEvents()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
      //  setupParkingLot()
        viewModel.placeCenter(search: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        floatingPanelController.addPanel(toParent: self, animated: false)
        
        
        // Test by Rao
        mapView.logoAlign = NMFLogoAlign.leftTop
        mapView.logoMargin = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
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
    
    func navigateToDetail(with element:WithinElement) {
        let target = Storyboard.detail.instantiateViewController(withIdentifier: "ParkinglotDetailNavigationController") as! ParkinglotDetailNavigationController
        target.setWithinElement(element)
        self.modal(target)
    }
    
    func navigateToReserveTicket() {
        let target = Storyboard.payment.instantiateViewController(withIdentifier: "PaymentNavigationController") as! UINavigationController
        self.modal(target)
    }
    
    func navigateToSearch(with coordinate:CoordType) {
        let target = Storyboard.search.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        target.setLocation(coordinate)
        self.modal(target)
        
        target.resultAction = { [unowned self] coordinate in
            self.showNavigationBar(true)
            target.dismissModal(animated: true, completion: {
                self.updateSearchResult(with: coordinate)
            })
        }
    }
    
    func navigateToTimeDialog() {
        let date = UserData.shared.getOnReserveDate()
        let productType = UserData.shared.productSettings.getProductType()
        
        if productType == .time {
            TimeTicketDialog.show(source: self, start: date.start, handler:{ (start, end) in
                self.viewModel.setTimeTicketRange(start: start, end: end)
            })
        } else if productType == .fixed {
            FixedTicketDialog.show(source: self, start: date.start, handler:{ (start, hours) in
                self.viewModel.setFixedTicketTime(start: start, hours: hours)
            })
        } else if productType == .monthly {
            MonthlyTicketDialog.show(source: self, start: date.start, handler:{ (start, months) in
                self.viewModel.setMonthlyTicketTime(start: start, months: months)
            })
        }
    }
    
    // MARK: Side Menu
    
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
    
    // MARK: Prepare

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParkingCardView" {
            if let destination = segue.destination as? ParkinglotCardViewController {
                self.cardViewController = destination
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
        floatingPanelController.addPanel(toParent: self, belowView: safeAreaView, animated: false)
    }
    
    //MARK: - FloatingPanelControllerDelegate
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return BottomFloatingLayout(bottomInset: self.parkingInfoBottomConstraint.constant)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return BottomFloatingPanelBehavior()
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        let y = vc.surfaceView.frame.origin.y
        let tipY = vc.originYOfSurface(for: .tip)
        
        debugPrint("[PANEL] Did Move :", y,", tip Y :", tipY)
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        debugPrint("[PANEL] Begin Dragging")
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        debugPrint("[PANEL] , target : ", targetPosition)
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
