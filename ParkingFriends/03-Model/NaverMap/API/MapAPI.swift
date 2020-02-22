//
//  MapAPI.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

struct MapAPI:BaseAPI {
    // Place
    static func search(query:String, coordinate:CoordType) -> RequestURL {
        let query:Params = ["query": query, "coordinate":"\(coordinate.longitude.toString),\(coordinate.latitude.toString)"]
        let url = build(host:map_host, endpoint:"/map-place/v1/search", query: query)
        
        return (url, nil)
    }
    
    // Geocode
    static func geocode(query:String) -> RequestURL {
        let query:Params = ["query": query]
        let url = build(host:map_host, endpoint:"/map-reversegeocode/v2/geocode", query: query)
        
        return (url, nil)
    }
    
    // Reverse Geocode
    static func reverse(request:String = "coordsToaddr", sourcesrs:CoordSystemType = .epsg_4326, coords:CoordType, output:OutputType = .json, orders:[MapOrders]) -> RequestURL {
        let mapOrders = orders.map{ $0.rawValue }.joined(separator: ",")
        let query:Params = ["request":request, "coords":"\(coords.longitude.toString),\(coords.latitude.toString)", "sourcecrs":sourcesrs.rawValue, "output":output.rawValue, "orders":mapOrders]
        
        let url = build(host:map_host, endpoint:"/map-reversegeocode/v2/gc", query: query)
        
        return (url, nil)
    }
 
}
