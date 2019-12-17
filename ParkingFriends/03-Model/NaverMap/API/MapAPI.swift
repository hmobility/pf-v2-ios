//
//  MapAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

struct MapAPI:BaseAPI {
    // Reverse Geocode
    static func reverse(request:String = "coordsToaddr", sourcesrs:CoordSystemType = .epsg_4326, coords:CoordType, output:OutputType = .json, orders:[MapOrders]) -> RequestURL {
        let mapOrders = orders.map{ $0.rawValue }.joined(separator: ",")
        let query:Params = ["request":request, "coords":"\(coords.longitude.toString),\(coords.latitude.toString)", "sourcecrs":sourcesrs.rawValue, "output":output.rawValue, "orders":mapOrders]
        
        let url = build(host:map_host, endpoint:"/map-reversegeocode/v2/gc", params: query)
        
        return (url, nil)
    }
 
}
