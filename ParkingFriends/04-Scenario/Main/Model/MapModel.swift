//
//  MapModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/27.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import NMapsMap


fileprivate let kBasicZoomLevel = 14.0
fileprivate let kMinZoomLevel = 10.0
fileprivate let kMaxZoomLevel = 16.0

fileprivate let kDisctrictZoomLevel = 12.5

typealias ExtentType = (southWestLat:Double, southWestLng:Double, northEastLat:Double, northEastLng:Double)

protocol MapModelType {
    var zoomLevel:BehaviorRelay<Double> { get }
    var maxZoomLevel:BehaviorRelay<Double> { get }
    var minZoomLevel:BehaviorRelay<Double> { get }
    
    var extent:BehaviorSubject<ExtentType> { get }
    
    var defaultZoomLevel:Double { get }
    var districtZoomLevel:Double { get }
    
    func cameraPosition()
    
    func zoomIn() -> Observable<Double>
    func zoomOut() -> Observable<Double>
    
    func isDistrictZoomLevel(_ zoomLevel:Double) -> Observable<Bool>
}

class MapModel: NSObject, MapModelType {
    var zoomLevel: BehaviorRelay<Double> = BehaviorRelay(value: kBasicZoomLevel)
    var maxZoomLevel: BehaviorRelay<Double> = BehaviorRelay(value: kMinZoomLevel)
    var minZoomLevel: BehaviorRelay<Double> = BehaviorRelay(value: kMaxZoomLevel)
    
    var districtZoomLevel:Double = kDisctrictZoomLevel
    
    var extent:BehaviorSubject<ExtentType> = BehaviorSubject(value:(southWestLat:31.43, southWestLng:122.37, northEastLat:44.35, northEastLng:132))
    
    var defaultZoomLevel:Double {
        get {
            return Double(kBasicZoomLevel)
        }
    }
    
    // MARK: - Initialize
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    func isDistrictZoomLevel(_ zoomLevel:Double) -> Observable<Bool> {
        return Observable.just(zoomLevel <= districtZoomLevel)
    }
    
    func zoomIn() -> Observable<Double> {
        if zoomLevel.value < maxZoomLevel.value {
            let value = zoomLevel.value
            zoomLevel.accept(value + 1)
        }
        
        return zoomLevel.map { return $0 }
    }
    
    func zoomOut() -> Observable<Double> {
        if zoomLevel.value > minZoomLevel.value {
            let value = zoomLevel.value
            zoomLevel.accept(value - 1)
        }
        
        return zoomLevel.map { return $0 }
    }
    
    func cameraPosition() {
       // let cameraPosition = NMFCameraPosition(NMGLatLng(from:position.coordinate), zoom: Double(self.zoomLevel.value), tilt: 0, heading: 0)
      //  self.centerOverlay(mapView.locationOverlay, location: cameraPosition)
    }
}

