//
//  OpenAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

class NaverMap: HttpSession {
    // Search
    static public func search(query:String, coordinate:CoordType) -> Observable<(places:[Place]?, MapResultCode)> {
        let data = MapAPI.search(query: query, coordinate: coordinate)
        
        return self.shared.dataTask(path: data.url, parameters: data.params)
            .map ({  result in
                //debugPrint("[SEARCH] ", result.data)
                let items:[Place] = result.data.map { (data) in
                    Place(JSON: data)!
                }
                
                let status:MapResultCode = MapResultCode(rawValue:result.status["status"] as! String) ?? .none
                
                return (places:items, status)
            })
    }
    
    // Reverse Geocoding
    static public func geocode(query:String) -> Observable<(geocode:[Geocode]?, MapResultCode)> {
        let data = MapAPI.geocode(query: query)
        
        return self.shared.dataTask(path: data.url, parameters: data.params)
            .map ({  result in
                //debugPrint("[REVERSE] ", result.data)
                let geocoode:[Geocode] = result.data.map { (data) in
                    Geocode(JSON: data)!
                }
                
                let status:MapResultCode = MapResultCode(rawValue:result.status["status"] as! String) ?? .none
                
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
