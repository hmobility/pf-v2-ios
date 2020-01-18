//
//  GroupMarkerWindow.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/23.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap

// MARK: - NMFInfoWindow - Custom

class DistrictMarkerWindow: NMFInfoWindow {
    private var element:WithinDistrictElement?
    private var markerSource:GroupMarkerDataSource?
    
    // MARK: - Initiailize
    
    init(district element:WithinDistrictElement, map:NMFMapView) {
        super.init()
        setDistrictElement(element)
        self.mapView = map
    }
    
    // MARK: - Public Methods
    
    public func remove() {
        self.mapView = nil
    }
    
    public func handler(_ touch:@escaping(_ element:WithinDistrictElement?) -> Void) {
        self.touchHandler = { (overlay: NMFOverlay) -> Bool in
            touch(self.element)
            return true
        }
    }
    
    // MARK: - Local Methods
    
    private func setDistrictElement(_ element:WithinDistrictElement) {
        self.element = element
        self.position = NMGLatLng(lat: element.lat.doubleValue, lng: element.lon.doubleValue)
       
        self.markerSource = GroupMarkerDataSource(count: element.count, district:element.name)
        self.dataSource = markerSource
    }
}

// MARK: - NMFOverlayImageDataSource

class GroupMarkerDataSource: NSObject {
    fileprivate var rootView: GroupMarkerView!
    fileprivate var districtName:String?
    fileprivate var count:Int = 0
    
    init(count:Int, district:String) {
        super.init()
        self.count = count
        self.districtName = district
    }
}

extension GroupMarkerDataSource: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        if rootView == nil {
            rootView = GroupMarkerView.loadFromXib()
        }
        
        if let districtName = districtName, count > 0 {
            rootView.count(count, district: districtName)
        }
        
        rootView.layoutIfNeeded()
        
        return rootView
    }
}

