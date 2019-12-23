//
//  OpenAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

class NaverMap: HttpSession {

    // Reverse Geocoding
    static public func reverse(orders:[MapOrders], coords:CoordType) -> Observable<(reverse:[ReverseGeocode]?, Status?)> {
        let data = MapAPI.reverse(coords:coords, orders:orders)

        return self.shared.dataTask(path: data.url, parameters: data.params)
            .map ({  result in
                //debugPrint("[REVERSE] ", result.data)
                let reverseCode:[ReverseGeocode] = result.data.map { (data) in
                    ReverseGeocode(JSON: data)!
                }
                
                return (reverse:reverseCode, result.status)
            })
    }
}
