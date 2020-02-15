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
    
    public var parkinglotId:Int {
        get {
            guard let elementId = element?.id else {
                return -1
            }
            
            return elementId
        }
    }
    
    public var selected:Bool {
        get {
            if let source = self.markerSource {
                return source.getSelectedStatus()
            }
            
            return false
        }
        set {
            if let source = self.markerSource {
                source.setSelected(newValue)
            }
        }
    }
    
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
            return .normal(selected: false)
        }
        
        return .disabled(selected: false)
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
    fileprivate var markerType: MarkerType = .normal(selected: false)
    fileprivate var price:Int?
    
    init(price:Int, type:MarkerType = .normal(selected: false)) {
        super.init()
        self.price = price
        self.markerType = type
    }
    
    func setSelected(_ flag:Bool) {
        rootView.setSelected(flag)
    }
    
    func getSelectedStatus() -> Bool {
        return rootView.selected
    }
}

extension MarkerDataSource: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        if rootView == nil {
            rootView = MarkerView.loadFromXib()
        }
        
        if let value = price {
            rootView.info(price: value, type: markerType)
        }
        
        return rootView
    }
}
