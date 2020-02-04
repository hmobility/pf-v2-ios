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
    static public func geocode(query:String) -> Observable<(geocode:[Geocode]?, String)> {
        let data = MapAPI.geocode(query: query)
        
        return self.shared.dataTask(path: data.url, parameters: data.params)
            .map ({  result in
                //debugPrint("[REVERSE] ", result.data)
                let geocoode:[Geocode] = result.data.map { (data) in
                    Geocode(JSON: data)!
                }
                
                let status:String = result.status["status"] as! String
                
                return (geocode:geocoode, status)
            })
    }

    // Reverse Geocoding
    static public func reverse(orders:[MapOrders], coords:CoordType) -> Observable<(reverse:[ReverseGeocode]?, ReverseStatus?)> {
        let data = MapAPI.reverse(coords:coords, orders:orders)

        return self.shared.dataTask(path: data.url, parameters: data.params)
            .map ({  result in
                //debugPrint("[REVERSE] ", result.data)
                let reverseCode:[ReverseGeocode] = result.data.map { (data) in
                    ReverseGeocode(JSON: data)!
                }
                
                let status:ReverseStatus = ReverseStatus(JSON: result.status)!
                
                return (reverse:reverseCode, status)
            })
    }
}
