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

extension Reactive where Base:NMFMapView {
    public var delegate: DelegateProxy<NMFMapView, NMFMapViewDelegate> {
          return RxMapViewDelegateProxy.proxy(for: base)
    }
    
    public var regionIsChanging: ControlEvent<(animated: Bool, reason: Int)> {
        let source = delegate.rx.methodInvoked(#selector(NMFMapViewDelegate.mapView(_:regionDidChangeAnimated:byReason:)))
            .map { obj in
                return (animated: try castOrThrow(Bool.self, obj[1]),
                        reason: try castOrThrow(Int.self, obj[2]))
            }
            .map { (animated, reason) in
                return (animated: animated, reason: reason)
            }
        return ControlEvent(events: source)
    }
}
