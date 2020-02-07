//
//  InfoWindow.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap

// MARK: - NMFInfoWindow - Custom

class MarkerWindow:NMFInfoWindow {
    private var element:WithinElement?
    private var markerSource:MarkerDataSource?
    
    // MARK: - Initiailize
    
    init(within element:WithinElement, map:NMFMapView) {
        super.init()
        setWithinElement(element)
        self.mapView = map
    }
    
    // MARK: - Public Methods
    
    public func remove() {
        self.mapView = nil
    }
    
    public func handler(_ touch:@escaping(_ element:WithinElement?) -> Void) {
        self.touchHandler = { (overlay: NMFOverlay) -> Bool in
            touch(self.element)
            return true
        }
    }
    
    // MARK: - Local Methods
    
    private func getMarkerType(available:Bool) -> MarkerType {
        if available {
//            return .green
            return .normal
        }
        
        return .disabled
    }
    
    private func setWithinElement(_ element:WithinElement) {
        self.element = element
        self.position = NMGLatLng(lat: element.lat.doubleValue, lng: element.lon.doubleValue)
        let markerType = getMarkerType(available:element.available)
        self.markerSource = MarkerDataSource(price:element.price, type:markerType)
        self.dataSource = markerSource
    }
}

// MARK: - NMFOverlayImageDataSource

class MarkerDataSource: NSObject {
    fileprivate var rootView: MarkerView!
    fileprivate var markerType: MarkerType = .normal
    fileprivate var price:Int?
    
    init(price:Int, type:MarkerType) {
        super.init()
        self.price = price
        self.markerType = type
    }
}

extension MarkerDataSource: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        if rootView == nil {
            rootView = MarkerView.loadFromXib()
        }
        
        if let _ = price {
            rootView.price(price!, type: markerType)
        }
        
        return rootView
    }
}
