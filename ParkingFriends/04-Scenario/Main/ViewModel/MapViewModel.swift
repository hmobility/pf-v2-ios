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
    
    private var markerList:[NMFInfoWindow]?
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
    
    func initialize() {
        setupLocationBinding()
        setupLocationOverlay()
        setupMapBinding()
    }
    
    // MARK: - Binding
    
    // NMFMapChangedByControl = -2
    // NMFMapChangedByGesture = -1
    // NMFMapChangedByDeveloper = 0
    
    func setupMapBinding() {
       // mapView?.delegate = self

        if let map = self.mapView {
            map.rx.regionDidChange.asDriver().drive(onNext: { (animated: Bool, reason: Int) in
                print("[REGION] didChange - ", reason)
            }, onCompleted: {
                print("[REGION] location completed")
            })
            .disposed(by: disposeBag)
            
            map.rx.idle.asDriver().drive(onNext: { _ in
                print("[IDLE] didChange completed")
                self.currentCenterInCamera()
                    .subscribe(onNext: { coord in
                        self.trackCameraMovement(coord: coord)
                    })
                    .disposed(by: self.disposeBag)
            }, onCompleted: {
                print("[IDLE] location completed")
            })
            .disposed(by: disposeBag)
        }
    }
    
    func setupLocationBinding() {
        _ = currentLocation().subscribe(onNext: { coordinate in
            self.placeCenter(coordinate, zoomLevel: self.mapModel.defaultZoomLevel)
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

    func makeMarker(coord:CoordType, type:MarkerType) {
        let marker = NMFMarker(position: NMGLatLng(lat: coord.latitude, lng: coord.longitude))
      //  marker.iconImage =
    }

    // MARK: - Local Methods
    
    private func trackCameraMovement(coord:CoordType) {
        self.requestReverseGeocoding(coord)
        self.showDestinationMarker(coord: coord)
        self.updateParkinglot(coord: coord, time: (start: "1600", end: "1800"))
    }
    
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
    
    private func placeCenter(_ coordinate:CLLocationCoordinate2D, zoomLevel:Double) {
        let position = NMFCameraPosition(NMGLatLng(from:coordinate), zoom: zoomLevel, tilt: 0, heading: 0)
        
        if let map = self.mapView {
            self.locationOverlay?.location = position.target
            map.moveCamera(NMFCameraUpdate(position:position))
        }
    }
    
    private func currentCenterInCamera() -> Observable<CoordType> {
        let coordinate:NMGLatLng = (self.mapView?.cameraPosition.target)!
        
        return Observable.just(CoordType(coordinate.lat, coordinate.lng))
    }
    
    private func currentLocation() -> Observable<CLLocationCoordinate2D> {
        locationManager.requestWhenInUseAuthorization()
       
        return locationManager.rx.location
            .map { location in
                return CLLocationCoordinate2DMake(testCoordinate.latitude, testCoordinate.longitude)
               // return location?.coordinate ?? CLLocationCoordinate2DMake(defaultCoordinate.latitude, defaultCoordinate.longitude)
            }
    }
    
    private func updateAddress(_ addr:String) {
        displayAddressText.accept(addr)
    }
    
    private func updateMarker(_ element:WithinElement) {
        let marker = MarkerWindow()
        
        let infoWindow = NMFInfoWindow()
        infoWindow.dataSource = marker
        infoWindow.position = NMGLatLng(lat: 37.5666102, lng: 126.9783881)
        infoWindow.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
            
            return true
        }
        
        markerList?.append(infoWindow)
    }
    
    private func updateParkinglot(coord:CoordType, time:(start:String, end:String)) {
        let option:FilterOption = UserData.shared.filter
        
        option.operationType = .public_area

        let start = Date().dateFor(.nearestMinute(minute:60)).toString(format: .custom("HHmm"))
        let end = Date().dateFor(.nearestMinute(minute:60)).adjust(.hour, offset: 2).toString(format: .custom("HHmm"))
        let today = Date().toString(format: .custom("yyyyMMdd"))
        
        self.within(coordinate: coord, filter: option.filter, month:(today, 1), time:(start, end))
            .subscribe(onNext: { elements in
                for item in elements {
                    debugPrint("[ITEM] ", item.address)
                }
            })
            .disposed(by: disposeBag)
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
    
    private func within(coordinate:CoordType, filter:FilterType, month:(from:String, count:Int), time:(start:String, end:String)) -> Observable<[WithinElement]> {
        return ParkingLot.within(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius:"1.4", start:time.start, end:time.end, productType:.time, monthlyFrom:month.from, monthlyCount:month.count, filter: filter).asObservable().map { (within, response) in
            return within?.elements ?? []
        }
    }
    
    // MARK: - Public Methdos
    
    func zoomIn() {
        if let map = self.mapView {
            map.zoomLevel =  mapModel.zoomIn()
        }
    }
    
    func zoomOut() {
        if let map = self.mapView {
            map.zoomLevel =  mapModel.zoomOut()
        }
    }
    
    // Move the camera to the current position
    func placeCenter() {
        self.currentLocation()
            .subscribe(onNext: { location in
                self.placeCenter(location, zoomLevel: self.mapModel.defaultZoomLevel)
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
        print("[mapViewIdle] ", mapView.latitude, ", ", mapView.longitude)
    }
    
    func mapView(_ mapView: NMFMapView, regionDidChangeAnimated animated: Bool, byReason reason: Int) {
        print("[regionDidChangeAnimated] ", mapView.latitude, ", ", mapView.longitude)
    }
    
    func mapView(_ mapView: NMFMapView, regionWillChangeAnimated animated: Bool, byReason reason: Int) {
        print("[regionWillChangeAnimated] ", mapView.latitude, ", ", mapView.longitude)
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        return false
    }
}
