//
//  MapModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/27.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import NMapsMap

protocol MapModelType {
    var zoomLevel:BehaviorRelay<Double> { get }
    var defaultZoomLevel:Double { get }
    
    func cameraPosition()
    
    func zoomIn() -> Observable<Double>
    func zoomOut() -> Observable<Double>
}

fileprivate let basicZoomLevel = 14.0
fileprivate let minZoomLevel = 10.0
fileprivate let maxZoomLevel = 16.0

fileprivate let disctrictZoomLevel = 15

class MapModel: NSObject, MapModelType {
    var zoomLevel:BehaviorRelay<Double> = BehaviorRelay(value: basicZoomLevel)
    
    var defaultZoomLevel:Double {
        get {
            return Double(basicZoomLevel)
        }
    }
    
    // MARK: - Initialize
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    func zoomIn() -> Observable<Double> {
        if zoomLevel.value < maxZoomLevel {
            let value = zoomLevel.value
            zoomLevel.accept(value + 1)
        }
        
        return zoomLevel.map { return $0 }
    }
    
    func zoomOut() -> Observable<Double> {
        if zoomLevel.value > minZoomLevel {
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

