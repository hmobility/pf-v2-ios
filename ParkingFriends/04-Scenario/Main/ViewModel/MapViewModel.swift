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
    
    func zoomIn()
    func zoomOut()
    func placeCenter()
}

class MapViewModel: NSObject, MapViewModelType {
    var mapView: NMFMapView?
    var locationOverlay: NMFLocationOverlay?
    
    private let locationManager = CLLocationManager()
    private let mapModel = MapModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, view:NMFMapView ) {
        self.mapView = view
        self.locationOverlay = mapView?.locationOverlay
        
        super.init()
        
        initialize()
    }
    
    func initialize() {
        setupLocationBinding()
        setupLocationOverlay()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
     
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
            overlay.circleColor = Color.algaeGreen
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
    
    func placeCenter() {
        self.currentLocation()
            .subscribe(onNext: { location in
                self.placeCenter(location, zoomLevel: self.mapModel.defaultZoomLevel)
            })
            .disposed(by: disposeBag)
    }
    
    func within(coordinate:CoordType) {
        
        typealias FilterType = (fee:(from:Int, to:Int), sortType:FilterSortType, operationType:FilterOperationType, areaType:FilterAreaType ,option:(cctv:Bool, iotSensor:Bool, mechanical:Bool, allDay:Bool))
        
        ParkingLot.within(lat: coordinate.latitude.toString, lon: coordinate.longitude.toString, radius: "1", sort: .distance, start: "", end: "", productType:.public_lot, monthlyFrom: "", monthlyCount: 1, filter: FilterType(fee:(from:500, to:1000), sortType:.low_price, operationType:.public_area, areaType:.outdoor, option:(cctv:false, iotSensor:false, mechanical:false, allDay:false))).asObservable()
            .subscribe(onNext: {(within, responseType) in
            }, onError: { error in
                        
            })
            .disposed(by: disposeBag)
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
