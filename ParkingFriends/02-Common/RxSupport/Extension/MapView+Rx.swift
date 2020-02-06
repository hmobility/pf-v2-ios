//
//  MapView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/27.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import NMapsMap

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}


extension Reactive where Base:  NMFMapView {
    public var zoomLevel: Binder<Double> {
        return Binder(self.base) { map, zoomLevel in
            map.zoomLevel = zoomLevel
        }
    }
    
    public var maxZoomLevel: Binder<Double> {
        return Binder(self.base) { map, zoomLevel in
            map.maxZoomLevel = zoomLevel
        }
    }
    
    public var minZoomLevel: Binder<Double> {
        return Binder(self.base) { map, zoomLevel in
            map.minZoomLevel = zoomLevel
        }
    }
    
    public var radius:Double {
        get {
            let width = UIScreen.main.nativeBounds.width / 2
            let metersPerPixel = self.base.projection.metersPerPixel()
            
            return (metersPerPixel * Double(width)) / 1000.0        //     Test by Rao
        }
    }
    // MRAK: - Delegate
        
    public var delegate: DelegateProxy<NMFMapView, NMFMapViewDelegate> {
          return RxMapViewDelegateProxy.proxy(for: base)
    }
    
    public var regionWillChange: ControlEvent<(animated: Bool, reason: Int)> {
        let source = delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapView(_:regionWillChangeAnimated:byReason:)))
            .map { obj in
                return (animated: try castOrThrow(Bool.self, obj[1]),
                        reason: try castOrThrow(Int.self, obj[2]))
        }
        .map { (animated, reason) in
            return (animated: animated, reason: reason)
        }
        return ControlEvent(events: source)
    }
    
    public var regionIsChanging: ControlEvent<(zoomLevel:Double, animated: Bool, reason: Int)> {
        let source = delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapView(_:regionDidChangeAnimated:byReason:)))
            .map { obj in
                return (zoomLevel: try castOrThrow(Double.self, (obj[0] as! NMFMapView).zoomLevel),
                    animated: try castOrThrow(Bool.self, obj[1]),
                    reason: try castOrThrow(Int.self, obj[2]))
            }
            .map { (zoomLevel, animated, reason) in
                return (zoomLevel: zoomLevel, animated: animated, reason: reason)
            }
        
        return ControlEvent(events: source)
    }

    
    public var regionDidChange: ControlEvent<(zoomLevel:Double, animated: Bool, reason: Int)> {
        let source = delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapView(_:regionDidChangeAnimated:byReason:)))
            .map { obj in
                return (zoomLevel: try castOrThrow(Double.self, (obj[0] as! NMFMapView).zoomLevel),
                        animated: try castOrThrow(Bool.self, obj[1]),
                        reason: try castOrThrow(Int.self, obj[2]))
            }
            .map { (zoomLevel, animated, reason) in
                return (zoomLevel:zoomLevel, animated: animated, reason: reason)
            }
        
        return ControlEvent(events: source)
    }
    
    public var cameraUpdateCancel: ControlEvent<Int> {
        let source = delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapViewCameraUpdateCancel(_:byReason:)))
            .map { obj in
                return try castOrThrow(Int.self, obj[1])
            }
            .map { reason in
                return reason
            }
        
        return ControlEvent(events: source)
    }
    
    public var idle: ControlEvent<Double> {
        let source = delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapViewIdle(_:)))
            .map { obj in
                return try castOrThrow(Double.self, (obj[0] as! NMFMapView).zoomLevel)
            }
            .map { zoomLevel in
                return (zoomLevel)
            }
       
        return ControlEvent(events: source)
    }
    
    public var didTapSymbol: ControlEvent<NMFSymbol> {
        let source = delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapView(_:didTap:)))
            .map { obj in
                return try castOrThrow(NMFSymbol.self, obj[1])
            }
            .map { symbol in
                return symbol
            }
        
        return ControlEvent(events: source)
    }
    
    public var didTapMapView: ControlEvent<(point:CGPoint, latlng:NMGLatLng)> {
        let source = delegate
            .methodInvoked(#selector(NMFMapViewDelegate.didTapMapView(_:latLng:)))
            .map { obj in
                return (point: try castOrThrow(CGPoint.self, obj[0]),
                latlng: try castOrThrow(NMGLatLng.self, obj[1]))
            }
            .map { (point, latlng) in
                return (point: point, latlng: latlng)
            }
        return ControlEvent(events: source)
    }
}
