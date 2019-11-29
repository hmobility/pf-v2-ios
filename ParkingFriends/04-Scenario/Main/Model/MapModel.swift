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
    var zoomLevel:Double { get }
    var defaultZoomLevel:Double { get }
    
    func cameraPosition()
    
    func zoomIn() -> Double
    func zoomOut() -> Double
}

fileprivate let basicZoomLevel = 14
fileprivate let minZoomLevel = 10
fileprivate let maxZoomLevel = 16

class MapModel: NSObject, MapModelType {
    
    var zoomLevel:Double = Double(basicZoomLevel)
    var defaultZoomLevel:Double {
        get {
            return Double(basicZoomLevel)
        }
    }
    
    override init() {
        super.init()
    }
    
    func zoomIn() -> Double {
        if Int(zoomLevel) < maxZoomLevel {
            zoomLevel = zoomLevel + 1
        }
        
        return Double(zoomLevel)
    }
    
    func zoomOut() -> Double {
        if Int(zoomLevel) > minZoomLevel {
            zoomLevel = zoomLevel - 1
        }
        
        return  Double(zoomLevel)
    }
    
    func cameraPosition() {
       // let cameraPosition = NMFCameraPosition(NMGLatLng(from:position.coordinate), zoom: Double(self.zoomLevel.value), tilt: 0, heading: 0)
      //  self.centerOverlay(mapView.locationOverlay, location: cameraPosition)
    }
}

