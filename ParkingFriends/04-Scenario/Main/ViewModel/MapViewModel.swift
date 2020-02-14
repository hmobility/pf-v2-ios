//
//  MainViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import NMapsMap

private enum CenterMarkType {
    case center, search
}

protocol MapViewModelType {
    var mapView: NMFMapView? { get set }
    
    var displayAddressText: BehaviorRelay<String> { get }
    var displayReservableTimeText: BehaviorRelay<String> { get }
    
    var cardViewModel:ParkingCardViewModelType? { get set }
    var parkingTapViewModel:ParkingTapViewModelType? { get set }
         
    var displaySettingSection: BehaviorRelay<(list:Bool, search:Bool)> { get set }
    
    func zoomIn()
    func zoomOut()
    func placeCenter(search:Bool)
    func userLocation() -> Observable<CoordType>
    func updateSearchResult(with coord:CoordType)
    func removeSearchResultMark()
    
    func setFocusedMarker(with parkinglotId:Int)

    func setTimeTicketRange(start startDate: Date, end endDate:Date)
    func setFixedTicketTime(start startDate: Date, hours:Int)
    func setMonthlyTicketTime(start startDate: Date, months:Int)
}

extension MapViewModelType {
    func placeCenter() {
        placeCenter(search: false)
    }
}

#if DEBUG
let defaultCoordinate = CoordType(37.400634765624986, 127.11203073310433)           // 판교 한컴 본사
//let defaultCoordinate = CoordType(37.51888371942195,126.9157924925587)              // 영등포 신길역
#else
let defaultCoordinate = CoordType(37.400634765624986, 127.11203073310433)           // 판교 한컴 본사
#endif

class MapViewModel: NSObject, MapViewModelType {
    var mapView: NMFMapView?
    var locationOverlay: NMFLocationOverlay?
    
    var displayAddressText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var displayReservableTimeText: BehaviorRelay<String>
    
    var displaySettingSection: BehaviorRelay<(list:Bool, search:Bool)> = BehaviorRelay(value:(list:false, search:true))
    
    var cardViewModel:ParkingCardViewModelType?
    var parkingTapViewModel:ParkingTapViewModelType?
    
    private var parkinglotList:[MarkerWindow] = []
    private var districtList:[DistrictMarkerWindow] = []
    
    private var destMarker:NMFMarker?
    private var searchMarker:NMFMarker?
    
    private let locationManager = CLLocationManager()
    private let mapModel = MapModel()
    private let userData:UserData
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize

    init(localizer: LocalizerType = Localizer.shared, userData:UserData = UserData.shared, view:NMFMapView) {
        self.mapView = view
        self.userData = userData
        
        self.locationOverlay = mapView?.locationOverlay
        
        let date = userData.getOnReserveDate()
        let displayTime = DisplayTimeHandler().displayReservableTime(start: date.start, end: date.end)
        
        displayReservableTimeText = BehaviorRelay(value: displayTime)
        
        destMarker = NMFMarker.init(position: NMGLatLng(lat: defaultCoordinate.latitude, lng: defaultCoordinate.longitude), iconImage: NMFOverlayImage(name: "icMapCenter"))
        searchMarker = NMFMarker.init(position: NMGLatLng(lat: defaultCoordinate.latitude, lng: defaultCoordinate.longitude), iconImage: NMFOverlayImage(name: "icMarkerDestination"))
    
        super.init()
        
        initialize()
    }
    
    func initialize() {
        setupLocationBinding()
        setupLocationOverlay()
        setupMapBinding()
    }
    
    // MARK: - Binding
    
    /*
     - reason
     NMFMapChangedByControl = -2
     NMFMapChangedByGesture = -1
     NMFMapChangedByDeveloper = 0
    */
    func setupMapBinding() {
        if let map = self.mapView {
            map.rx.regionDidChange
                .asDriver()
                .drive(onNext: { (zoomLevel:Double, animated: Bool, reason: Int) in
                    self.currentCenterInCamera(zoomLevel: zoomLevel)
                        .subscribe(onNext: { (zoomLevel, coord) in
//                            self.trackCameraMovement(coord: coord, zoomLevel: zoomLevel)      // Delete by Rao
                        })
                        .disposed(by: self.disposeBag)
              
                print("[REGION] Level :\(map.zoomLevel) / didChange - ", reason)
            }, onCompleted: {
                print("[REGION] location completed")
            })
            .disposed(by: disposeBag)
            
            map.rx.idle
                .asDriver()
                .drive(onNext: { zoomLevel in
                    print("[IDLE] didChange completed")
                    self.currentCenterInCamera(zoomLevel: zoomLevel)
                        .subscribe(onNext: { (zoomLevel, coord) in
                            self.trackCameraMovement(coord: coord, zoomLevel: zoomLevel)
                        })
                        .disposed(by: self.disposeBag)
                }, onCompleted: {
                    print("[IDLE] location completed")
                })
                .disposed(by: disposeBag)
            
            mapModel.extent
                .asObservable()
                .subscribe(onNext: { extent in
                   map.extent = NMGLatLngBounds(southWestLat: extent.southWestLat, southWestLng: extent.southWestLng, northEastLat: extent.northEastLat, northEastLng: extent.northEastLng)
                })
                .disposed(by: disposeBag)
            
            mapModel.zoomLevel
                .asDriver()
                .drive(map.rx.zoomLevel)
                .disposed(by: disposeBag)
            /*
            mapModel.maxZoomLevel
                .asDriver()
                .drive(map.rx.maxZoomLevel)
                .disposed(by: disposeBag)
            
            mapModel.minZoomLevel
                .asDriver()
                .drive(map.rx.minZoomLevel)
                .disposed(by: disposeBag)
             */
        }
    }
    
    func setupLocationBinding() {
        _ = currentLocation().subscribe(onNext: { coordinate in
            self.setCenterPosition(with: coordinate, zoomLevel: self.mapModel.defaultZoomLevel)
        }).disposed(by: disposeBag)
    }
    
    func setupLocationOverlay() {
        if let overlay = self.locationOverlay {
            overlay.circleOutlineWidth = 0
            overlay.hidden = false
            overlay.icon = NMFOverlayImage(name: "icCenterOval")
            overlay.subIcon = nil
            overlay.circleColor = Color.algaeGreen2
        }
    }

    // MARK: - Local Methods
    
    func updateSubModel(district:Bool, within elements:[WithinElement]?, section:(list:Bool, search:Bool)? = nil) {
        if district {
            self.updateTapElements(nil)
            self.updateCardElements(nil)
            displaySettingSection.accept(section ?? (list:false, search:true))
        } else {
            self.updateTapElements(elements)
            self.updateCardElements(elements)
            let showList = (elements?.count ?? 0) > 0 ? true : false
            displaySettingSection.accept(section ?? (list:showList, search:!showList))
        }
    }
    
    func updateCardElements(_ elements:[WithinElement]?) {
        if let viewModel = cardViewModel {
            viewModel.setWithinElements(elements)
        }
    }
    
    func updateTapElements(_ elements:[WithinElement]?) {
        if let viewModel = parkingTapViewModel {
            viewModel.setWithinElements(elements)
        }
    }
    
    // MARK: - Marker

    // 개별 주차면 표시
    func generateMarker(within element:WithinElement) -> MarkerWindow? {
        if let map = mapView {
            return MarkerWindow(within:element, map:map)
        }
        
        return nil
    }
    
    // 구별 주차면 표시
    func generateDistrict(district element:WithinDistrictElement) -> DistrictMarkerWindow? {
        if let map = mapView {
            return DistrictMarkerWindow(district:element, map:map)
        }
        
        return nil
    }
    
    private func removeCenterMark(_ centerType:CenterMarkType) {
        switch centerType {
            case .center:
                destMarker?.mapView = nil
            case .search:
                searchMarker?.mapView = nil
        }
    }
    
    // 지도 이동시 중심 마크 표시
    private func showDestinationMarker(coord:CoordType, centerType:CenterMarkType = .center) {
        if let map = self.mapView {
            let location = map.locationOverlay.location
            let center = CLLocation(latitude:location.lat, longitude: location.lng)
            let destination = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            
            var targetMark:NMFMarker?
            
            switch centerType {
            case .center:
                targetMark = destMarker
            case .search:
                targetMark = searchMarker
            }
    
            if let mark = targetMark {
                mark.isForceShowIcon = true
                mark.position = NMGLatLng(lat: coord.latitude, lng: coord.longitude)
                mark.mapView = (destination.distance(from: center) > 10) ? map : nil
            }
        }
    }
    
    func updateMarker(lots:[WithinElement]? = nil, districts:[WithinDistrictElement]? = nil) {
        if parkinglotList.count > 0 {
            for item in parkinglotList {
                item.remove()
            }
      
            parkinglotList = []
        }
        
        if districtList.count > 0 {
            for item in districtList {
                item.remove()
            }
     
            districtList = []
        }
        
        if let elements = lots {
            for item in elements {
//                debugPrint("[LOT] ", item.address)    // Delete by Rao
                if let marker = generateMarker(within: item) {
                    parkinglotList.append(marker)
                }
            }
        }
        
        if let elements = districts {
            for item in elements {
//                debugPrint("[DISTRICT] ", item.name)
                if let marker = generateDistrict(district: item) {
                    districtList.append(marker)
                }                                                      
            }
        }
    }
    
    func updateMarkerStatus(focused flag:Bool, parkinglotId:Int) {
        if parkinglotList.count > 0 {
            
            if let item = parkinglotList.filter({ $0.selected }).first {
                item.selected = false
            }
            
            if let item = parkinglotList.filter({ $0.parkinglotId == parkinglotId }).first {
                item.selected = true
            }
            
            parkinglotList.forEach { item in
                print("[\(item.parkinglotId) = \(item.selected)")
            }
        }
    }

    // MARK: - Camera Moving
    
    func trackCameraMovement(coord:CoordType, zoomLevel:Double) {
        self.requestReverseGeocoding(coord)
        self.showDestinationMarker(coord: coord)
        
        debugPrint("[ZOOM] ", zoomLevel)
        
        mapModel.isDistrictZoomLevel(zoomLevel)
            .asObservable()
            .subscribe(onNext: { (district) in
                self.updateParkinglot(coord:coord, district:district)
            })
            .disposed(by: disposeBag)
    }
    
    func currentCenterInCamera(zoomLevel:Double = 16) -> Observable<(Double, CoordType)> {
        let coordinate:NMGLatLng = (self.mapView?.cameraPosition.target)!
        
        return Observable.just((zoomLevel, CoordType(coordinate.lat, coordinate.lng)))
    }
    
    // MARK: - Address (Reverse Geocoding)
    
    func updateAddress(_ addr:String) {
        displayAddressText.accept(addr)
    }
    
    // MARK: - Handle Location
    
    fileprivate func updateCamera(with coordinate:CoordType, centerType:CenterMarkType) {
        let location = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        let position = NMGLatLng(from: location)
        
        let params = NMFCameraUpdateParams()
        params.scroll(to: position)
 
        if let map = self.mapView {
            self.showDestinationMarker(coord: coordinate, centerType: centerType)
            map.moveCamera(NMFCameraUpdate(params: params))
        }
    }
    
    func setCenterPosition(with coordinate:CLLocationCoordinate2D, zoomLevel:Double) {
        let position = NMFCameraPosition(NMGLatLng(from:coordinate), zoom: zoomLevel, tilt: 0, heading: 0)
        
        if let map = self.mapView {
            self.locationOverlay?.location = position.target
            map.moveCamera(NMFCameraUpdate(position:position))
        }
    }
    
    func currentLocation() -> Observable<CLLocationCoordinate2D> {
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager.rx.location
            .map { location in
                if let available = location, available.verticalAccuracy < 0  || available.horizontalAccuracy < 0 {
                    return CLLocationCoordinate2DMake(defaultCoordinate.latitude, defaultCoordinate.longitude)
                }
                
            return location?.coordinate ?? CLLocationCoordinate2DMake(defaultCoordinate.latitude, defaultCoordinate.longitude)
        }
    }
    
    func updateParkinglot(coord:CoordType, district:Bool = false, search:Bool = false) {
        let option:FilterOption = UserData.shared.filter
        let radius = self.mapView!.rx.radius
        
        debugPrint("[RADIUS] ", radius)
        let time = UserData.shared.getOnReserveTime()
        let today = Date().toString(format: .custom("yyyyMMdd"))
        
        if district == true {
            self.withinDistrict(coordinate: coord, radius: radius)
                .subscribe(onNext: { elements in
                    self.updateMarker(districts: elements)
                    self.updateSubModel(district: true, within: nil)
                })
                .disposed(by: disposeBag)
        } else {
            self.within(coordinate:coord, radius: radius, filter:option.filter, month:(today, 1), time:(time.start, time.end))
                .subscribe(onNext: { elements in
                    self.updateMarker(lots: elements)
                    self.updateSubModel(district: false, within: elements, section: search ? (list:false, search:true) : nil)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Network
    
    func requestReverseGeocoding(_ location:CoordType) {
        NaverMap.reverse(orders: [.roadaddr, .addr], coords: location)
            .subscribe(onNext: { (reverse, status) in
                if let reverseGeocode = reverse, reverseGeocode.count > 0 {
                    let item = reverseGeocode[0]

                    if let addr = item.shortAddress {
                        self.updateAddress(addr)
                    }
                }
            }, onError: { error in
                
            })
            .disposed(by: disposeBag)
    }
    
    func within(coordinate:CoordType, radius:Double, filter:FilterType, month:(from:String, count:Int), time:(start:String, end:String)) -> Observable<[WithinElement]> {
        return ParkingLot.within(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius:radius.toString, start:time.start, end:time.end, productType:.time, monthlyFrom:month.from, monthlyCount:month.count, filter: filter)
            .asObservable()
            .map { (within, response) in
                return within?.elements ?? []
            }
    }
    
    func withinDistrict(coordinate:CoordType, radius:Double) -> Observable<[WithinDistrictElement]> {
        return ParkingLot.within_district(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius: radius.toString)
            .asObservable()
            .map { (district, response) in
                return district?.elements ?? []
            }
    }
    
    // MARK: - Public Methdos
    
    public func zoomIn() {
        if let map = self.mapView {
            mapModel.zoomIn()
                .asObservable()
                .bind(to: map.rx.zoomLevel)
                .disposed(by: disposeBag)
        }
    }
    
    public func zoomOut() {
        if let map = self.mapView {
            mapModel.zoomIn()
                .asObservable()
                .bind(to: map.rx.zoomLevel)
                .disposed(by: disposeBag)
        }
    }
    
    // Move the camera to the current position
    public func placeCenter(search:Bool) {
        self.currentLocation()
            .subscribe(onNext: { location in
                self.setCenterPosition(with: location, zoomLevel:self.mapModel.defaultZoomLevel)
                self.requestReverseGeocoding(CoordType(location.latitude, location.longitude))
                self.updateParkinglot(coord: CoordType(location.latitude, location.longitude), search: search)
            }).disposed(by: disposeBag)
    }
    
    // To get user location for searching place
    public func userLocation() -> Observable<CoordType> {
        return currentLocation()
            .asObservable()
            .map { location in
                return CoordType(latitude: location.latitude, longitude: location.longitude)
            }
    }
    
    public func updateSearchResult(with coord:CoordType) {
        self.updateCamera(with: coord, centerType: .search)
    }
    
    public func removeSearchResultMark() {
        self.removeCenterMark(.search)
    }
    
    public func setFocusedMarker(with parkinglotId:Int) {
        updateMarkerStatus(focused: true, parkinglotId: parkinglotId)
    }
    
    // MARK: Time Option
    
    public func setTimeTicketRange(start startDate: Date, end endDate:Date) {
        UserData.shared.setOnReserveTime(start:startDate, end:endDate)
        let displayText = DisplayTimeHandler().displayReservableTime(start: startDate, end: endDate)
        
        self.displayReservableTimeText.accept(displayText)
    }
    
    public func setFixedTicketTime(start startDate: Date, hours:Int) {
        let endDate = startDate.adjust(.hour, offset: hours)
        UserData.shared.setOnReserveTime(start:startDate, end:endDate)
        let displayText = DisplayTimeHandler().diplayFixedTicketFromDate(date: startDate, hours: hours)
        
        self.displayReservableTimeText.accept(displayText)
    }
    
    public func setMonthlyTicketTime(start startDate: Date, months:Int) {
        
    }
    
}
