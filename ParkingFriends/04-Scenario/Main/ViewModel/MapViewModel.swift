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

class MapViewModel: NSObject, MapViewModelType {
    var mapView: NMFMapView?
    var locationOverlay: NMFLocationOverlay?
    
    var displayAddressText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var displayReservedTimeText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let locationManager = CLLocationManager()
    private let mapModel = MapModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, view:NMFMapView ) {
        self.mapView = view
        self.locationOverlay = mapView?.locationOverlay
        
        super.init()
        
        // Add by Rao
        self.mapView?.delegate = self
        
        initialize()
    }
    
    func initialize() {
        setupNavigationBinding()
        setupLocationBinding()
        setupLocationOverlay()
    }
    
    // MARK: - Binding
    
    func setupNavigationBinding() {
        
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

    // MARK: - Local Methods
    
    func placeCenter(_ coordinate:CLLocationCoordinate2D, zoomLevel:Double) {
        let position = NMFCameraPosition(NMGLatLng(from:coordinate), zoom: zoomLevel, tilt: 0, heading: 0)
        
        if let map = self.mapView {
            self.locationOverlay?.location = position.target
            map.moveCamera(NMFCameraUpdate(position:position))
        }
    }
    
    func currentLocation() -> Observable<CLLocationCoordinate2D> {
        locationManager.requestWhenInUseAuthorization()
       
        return locationManager.rx.location.map { location in
            return location!.coordinate
        }
    }
    
    func updateAddress(_ addr:String) {
        displayAddressText.accept(addr)
    }
    
    // MARK: - Local Methods
    
    func requestReverseGeocoding(_ location:CoordType) {
        NaverMap.reverse(orders: [.roadaddr], coords: location)
            .subscribe(onNext: { (reverse, status) in
                if let reverseGeocode = reverse, reverseGeocode.count > 0 {
                    let item = reverseGeocode[0]

                    if let result = item.shortAddress {
                        self.updateAddress(result)
                    }
                }
            }, onError: { error in
                
            })
            .disposed(by: disposeBag)
    }
    
    func within(coordinate:CoordType, filter:FilterType, time:(start:String, end:String)) {
        ParkingLot.within(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius:"1", sort:.distance, start:time.start, end:time.end, productType:.fixed, monthlyFrom:"", monthlyCount:1, filter: filter).asObservable()
            .subscribe(onNext: {(within, responseType) in
            }, onError: { error in
                        
            })
            .disposed(by: disposeBag)
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
                var testLocation = location
                if Platform.isSimulator {
                    testLocation = CLLocationCoordinate2D(latitude: 37.399991198158204, longitude: 127.10240788757801)     // Test by Rao
                }
                self.placeCenter(testLocation, zoomLevel: self.mapModel.defaultZoomLevel)
                self.requestReverseGeocoding(CoordType(testLocation.latitude, testLocation.longitude))
            }).disposed(by: disposeBag)
    }
    
}

// MARK:- MapView Delegate

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

// Add by Rao
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
