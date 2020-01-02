//
//  RxTextFieldDelegateProxy.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/21.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap

open class RxMapViewDelegateProxy: DelegateProxy<NMFMapView, NMFMapViewDelegate>, DelegateProxyType, NMFMapViewDelegate {
    
    public weak private(set) var mapView: NMFMapView?
    
    public static func currentDelegate(for object: NMFMapView) -> NMFMapViewDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: NMFMapViewDelegate?, to object: NMFMapView) {
        object.delegate = delegate
    }
    
    /// - parameter textfield: Parent object for delegate proxy.
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMapViewDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        register { RxMapViewDelegateProxy(mapView: $0)}
    }
    
    @objc(mapView:didTapSymbol:) open func mapView(_ mapView: NMFMapView, didTap symbol:NMFSymbol) -> Bool {
        return forwardToDelegate()?.mapView?(mapView, didTap: symbol) ?? true
    }
}
