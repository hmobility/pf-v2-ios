//
//  ParkingLot.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkingLot : HttpSession {
    static public func parkinglots(lat:String, long:String, radius:String, sort:SortType, start:String, end:String, productType:ProductType) -> Observable<(Parkinglots?, ResponseCodeType)>  {
        let data = ParkingLotAPI.parkinglots(lat: lat, long: long, radius: radius, sort: sort, start:start, end: end, productType: productType)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Parkinglots(JSON: result.data!), result.codeType)
            })
    }
}
