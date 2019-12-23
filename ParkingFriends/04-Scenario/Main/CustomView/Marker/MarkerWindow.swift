//
//  InfoWindow.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/18.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap

class MarkerWindow: NSObject {
    fileprivate var rootView: MarkerView!
    
    fileprivate var element:WithinElement?
    
    static public func generate(_ element:WithinElement, coord:CoordType, mapView:NMFMapView, handler:@escaping(WithinElement?) -> Void) {
        let marker = MarkerWindow()
        let infoWindow = NMFInfoWindow()
        infoWindow.dataSource = marker// as? NMFOverlayImageDataSource
        infoWindow.position = NMGLatLng(lat: coord.latitude, lng: coord.longitude)
        infoWindow.touchHandler = { (overlay: NMFOverlay) -> Bool in
            let window = overlay as! NMFInfoWindow
            
            handler(element)
            return true
        }
    }
    
    public func dataSource(_ source:WithinElement) {
        element = source
    }
    
    private func getMarkerType(available:Bool) -> MarkerType {
        if available {
            return .green
        }
        
        return .disabled
    }
}

// MARK: - NMFOverlayImageDataSource

extension MarkerWindow: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        if rootView == nil {
            rootView = MarkerView.loadFromXib()
        }
        
        if let data = element {
            let markerType = getMarkerType(available: data.available)
            rootView.price(data.price, type: markerType)
        }
        
        return rootView
    }
}
