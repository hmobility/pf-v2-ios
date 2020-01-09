//
//  MainViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/11.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import NMapsMap

protocol MapViewModelType {
    var mapView: NMFMapView? { get set }
    
    var displayAddressText: BehaviorRelay<String> { get }
    var displayReservedTimeText: BehaviorRelay<String> { get }
    
    var cardViewModel:ParkingCardViewModelType? { get set }
    var parkingTapViewModel:ParkingTapViewModelType? { get set }
         
    var displaySettingSection: BehaviorRelay<(list:Bool, search:Bool)> { get set }
    
    func zoomIn()
    func zoomOut()
    func placeCenter()
}

let defaultCoordinate = CoordType(37.400634765624986, 127.11203073310433)
let testCoordinate = CoordType(37.51888371942195,126.9157924925587)

class MapViewModel: NSObject, MapViewModelType {
    var mapView: NMFMapView?
    var locationOverlay: NMFLocationOverlay?
    
    var displayAddressText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var displayReservedTimeText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var displaySettingSection: BehaviorRelay<(list:Bool, search:Bool)> = BehaviorRelay(value:(list:false, search:true))
    
    var cardViewModel:ParkingCardViewModelType?
    var parkingTapViewModel:ParkingTapViewModelType?
    
    private var lotList:[MarkerWindow] = []
    private var districtList:[GroupMarkerWindow] = []
    
    private var destMarker:NMFMarker?
    
    private let locationManager = CLLocationManager()
    private let mapModel = MapModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, view:NMFMapView ) {
        self.mapView = view
        self.locationOverlay = mapView?.locationOverlay
        
        destMarker = NMFMarker.init(position: NMGLatLng(lat: defaultCoordinate.latitude, lng: defaultCoordinate.longitude), iconImage: NMFOverlayImage(name: "icMarkerDestination"))
    
        super.init()
        
        initialize()
    }
    
    private func initialize() {
        setupLocationBinding()
        setupLocationOverlay()
        setupMapBinding()
        //mapView?.delegate = self
    }
    
    // MARK: - Binding
    
    /*
     - reason
     NMFMapChangedByControl = -2
     NMFMapChangedByGesture = -1
     NMFMapChangedByDeveloper = 0
    */
    private func setupMapBinding() {
       // mapView?.delegate = self

        if let map = self.mapView {
            map.rx.regionDidChange.asDriver().drive(onNext: { (zoomLevel:Double, animated: Bool, reason: Int) in
                self.currentCenterInCamera(zoomLevel: zoomLevel)
                    .subscribe(onNext: { (zoomLevel, coord) in
                        self.trackCameraMovement(coord: coord, zoomLevel: zoomLevel)
                    })
                    .disposed(by: self.disposeBag)
              
                print("[REGION] Level :\(map.zoomLevel) / didChange - ", reason)
            }, onCompleted: {
                print("[REGION] location completed")
            })
            .disposed(by: disposeBag)
            
            map.rx.idle.asDriver().drive(onNext: { zoomLevel in
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
    
    private func setupLocationBinding() {
        _ = currentLocation().subscribe(onNext: { coordinate in
            self.placeCenter(coordinate, zoomLevel: self.mapModel.defaultZoomLevel)
        }).disposed(by: disposeBag)
    }
    
    private func setupLocationOverlay() {
        if let overlay = self.locationOverlay {
            overlay.circleOutlineWidth = 0
            overlay.hidden = false
            overlay.icon = NMFOverlayImage(name: "icCenterOval")
            overlay.subIcon = nil
            overlay.circleColor = Color.algaeGreen2
        }
    }
    
    // MARK: - Local Methods
    
    private func updateCardElements(_ elements:[WithinElement]) {
        if let viewModel = cardViewModel {
            viewModel.setWithinElements(elements)
        }
    }
    
    private func updateTapElements(_ elements:[WithinElement]) {
        if let viewModel = parkingTapViewModel {
            viewModel.setWithinElements(elements)
        }
    }
    
    // MARK: - Marker

    // 개별 주차면 표시
    private func generateMarker(within element:WithinElement) -> MarkerWindow? {
        if let map = mapView {
            return MarkerWindow(within:element, map:map)
        }
        
        return nil
    }
    
    // 구별 주차면 표시
    private func generateGroup(district element:WithinDistrictElement) -> GroupMarkerWindow? {
        if let map = mapView {
            return GroupMarkerWindow(district:element, map:map)
        }
        
        return nil
    }
    
    // 지도 이동시 중심 마크 표시
    private func showDestinationMarker(coord:CoordType) {
        if let map = self.mapView {
            let location = map.locationOverlay.location
            let center = CLLocation(latitude:location.lat, longitude: location.lng)
            let destination = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            
            if let marker = destMarker {
                marker.position = NMGLatLng(lat: coord.latitude, lng: coord.longitude)
                marker.mapView = (destination.distance(from: center) > 10) ? map : nil
            }
        }
    }
    
    private func updateMarker(lots:[WithinElement]? = nil, districts:[WithinDistrictElement]? = nil) {
        if lotList.count > 0 {
            for item in lotList {
                item.remove()
            }
      
            lotList = []
        }
        
        if districtList.count > 0 {
            for item in districtList {
                item.remove()
            }
     
            districtList = []
        }
        
        if let elements = lots {
            displaySettingSection.accept((list:true, search:false))
            updateCardElements(elements)
            updateTapElements(elements)
            
            for item in elements {
                debugPrint("[LOT] ", item.address)
                if let marker = generateMarker(within: item) {
                    lotList.append(marker)
                }
            }
        }
        
        if let elements = districts {
            displaySettingSection.accept((list:false, search:true))
            updateCardElements([])
            updateTapElements([])
            
            for item in elements {
                debugPrint("[DISTRICT] ", item.name)
                if let marker = generateGroup(district: item) {
                    districtList.append(marker)
                }
            }
        }
    }

    // MARK: - Camera Moving
    
    private func trackCameraMovement(coord:CoordType, zoomLevel:Double) {
        self.requestReverseGeocoding(coord)
        self.showDestinationMarker(coord: coord)
        
        mapModel.isDistrictZoomLevel(zoomLevel)
            .asObservable()
            .subscribe(onNext: { (district) in
                self.updateParkinglot(coord:coord, district:district, time:(start: "1600", end: "1800"))
            })
            .disposed(by: disposeBag)
    }
    
    private func currentCenterInCamera(zoomLevel:Double = 16) -> Observable<(Double, CoordType)> {
        let coordinate:NMGLatLng = (self.mapView?.cameraPosition.target)!
        
        return Observable.just((zoomLevel, CoordType(coordinate.lat, coordinate.lng)))
    }
    
    // MARK: - Address (Reverse Geocoding)
    
    private func updateAddress(_ addr:String) {
        displayAddressText.accept(addr)
    }
    
    
    // MARK: - Handle Location
    
    private func updateCamera(_ coordinate:CLLocationCoordinate2D) {
        let position = NMGLatLng(from:coordinate)
        
        let params = NMFCameraUpdateParams()
 //       params.zoom(to: zoomLevel)
        params.scroll(to: position)
 
        if let map = self.mapView {
            self.locationOverlay?.location = position
            map.moveCamera(NMFCameraUpdate(params: params))
        }
    }
    
    private func placeCenter(_ coordinate:CLLocationCoordinate2D, zoomLevel:Double) {
        let position = NMFCameraPosition(NMGLatLng(from:coordinate), zoom: zoomLevel, tilt: 0, heading: 0)
        
        if let map = self.mapView {
            self.locationOverlay?.location = position.target
            map.moveCamera(NMFCameraUpdate(position:position))
        }
    }
    
    private func currentLocation() -> Observable<CLLocationCoordinate2D> {
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager.rx.location
            .map { location in
                //return CLLocationCoordinate2DMake(testCoordinate.latitude, testCoordinate.longitude)
                //return location?.coordinate ?? CLLocationCoordinate2DMake(defaultCoordinate.latitude, defaultCoordinate.longitude)
                return location?.coordinate ?? CLLocationCoordinate2DMake(testCoordinate.latitude, testCoordinate.longitude)
            }
    }
    
    private func updateParkinglot(coord:CoordType, district:Bool = false, time:(start:String, end:String)) {
        let option:FilterOption = UserData.shared.filter
        
        option.lotType = .none
        
        let radius = self.mapView!.rx.radius

        debugPrint("[RADIUS] ", radius)

        let start = Date().dateFor(.nearestMinute(minute:10)).toString(format: .custom("HHmm"))
        let end = Date().dateFor(.nearestMinute(minute:10)).adjust(.hour, offset: 2).toString(format: .custom("HHmm"))
        let today = Date().toString(format: .custom("yyyyMMdd"))
        
        if district == true {
            self.withinDistrict(coordinate: coord, radius: radius)
                .subscribe(onNext: { elements in
                    self.updateMarker(districts: elements)
                })
                .disposed(by: disposeBag)
        } else {
            self.within(coordinate:coord, radius: radius, filter:option.filter, month:(today, 1), time:(start, end))
                .subscribe(onNext: { elements in
                    self.updateMarker(lots: elements)
                })
              .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Network
    
    private func requestReverseGeocoding(_ location:CoordType) {
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
    
    private func within(coordinate:CoordType, radius:Double, filter:FilterType, month:(from:String, count:Int), time:(start:String, end:String)) -> Observable<[WithinElement]> {
        return ParkingLot.within(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius:radius.toString, start:time.start, end:time.end, productType:.time, monthlyFrom:month.from, monthlyCount:month.count, filter: filter)
            .asObservable()
            .map { (within, response) in
                return within?.elements ?? []
            }
    }
    
    private func withinDistrict(coordinate:CoordType, radius:Double) -> Observable<[WithinDistrictElement]> {
        return ParkingLot.within_district(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius: radius.toString)
            .asObservable()
            .map { (district, response) in
                return district?.elements ?? []
            }
    }
    
    // MARK: - Public Methdos
    
    func zoomIn() {
        if let map = self.mapView {
            mapModel.zoomIn()
                .asObservable()
                .bind(to: map.rx.zoomLevel)
                .disposed(by: disposeBag)
        }
    }
    
    func zoomOut() {
        if let map = self.mapView {
            mapModel.zoomIn()
                .asObservable()
                .bind(to: map.rx.zoomLevel)
                .disposed(by: disposeBag)
        }
    }
    
    // Move the camera to the current position
    func placeCenter() {
        self.currentLocation()
            .subscribe(onNext: { location in
                self.placeCenter(location, zoomLevel:self.mapModel.defaultZoomLevel)
                self.requestReverseGeocoding(CoordType(location.latitude, location.longitude))
                self.updateParkinglot(coord: CoordType(location.latitude, location.longitude), time: (start: "1600", end: "1800"))
            }).disposed(by: disposeBag)
    }
}

// MARK:- MapView Delegate
// Deprecated

extension MapViewModel: NMFMapViewDelegate {
    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {

    }
    
    func mapViewRegionIsChanging(_ mapView: NMFMapView, byReason reason: Int) {
        print("[mapViewRegionIsChanging] ", mapView.latitude, ", ", mapView.longitude, " , [R]",  reason)
    }
    
    func mapViewIdle(_ mapView: NMFMapView) {
        print("[mapViewIdle] zoomLevel: ", mapView.zoomLevel, "(\(mapView.latitude),\(mapView.longitude))" )
    }
    
    func mapView(_ mapView: NMFMapView, regionDidChangeAnimated animated: Bool, byReason reason: Int) {
        print("[regionDidChangeAnimated] zoomLevel: ", mapView.zoomLevel, "(\(mapView.latitude),\(mapView.longitude)) , reason: ", reason)
    }
    
    func mapView(_ mapView: NMFMapView, regionWillChangeAnimated animated: Bool, byReason reason: Int) {
        print("[regionWillChangeAnimated] zoomLevel: ", mapView.zoomLevel, "(\(mapView.latitude),\(mapView.longitude)), reason: ", reason)
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        return false
    }
}

