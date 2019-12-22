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
        let data = ParkinglotAPI.parkinglots(lat: lat, long: long, radius: radius, sort: sort, start:start, end: end, productType: productType)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Parkinglots(JSON: result.data), result.codeType)
            })
    }
    
    static public func parkinglots(id:Int, from:String, to:String, type:ProductType, monthlyFrom:String, monthlyCount:Int) -> Observable<(Parkinglot?, ResponseCodeType)>  {
        let data = ParkinglotAPI.parkinglots(id: id, from: from, to: to, type:type, monthlyFrom: monthlyFrom, monthlyCount: monthlyCount)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Parkinglot(JSON: result.data), result.codeType)
            })
    }
    
    static public func share(address:String, images:[Image]) -> Observable<ResponseCodeType>  {
        let data = ParkinglotAPI.share(address: address, images: images)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func favorites() -> Observable<ResponseCodeType>  {
        let data = ParkinglotAPI.favorites()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func favorites(parkinglotId:Int) -> Observable<ResponseCodeType>  {
        let data = ParkinglotAPI.favorites(parkinglotId:parkinglotId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    static public func delete_favorites(parkinglotId:Int) -> Observable<ResponseCodeType>  {
        let data = ParkinglotAPI.delete_favorites(parkinglotId:parkinglotId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
    
    // 주차장 반경 목록 조회  /v1/parkinglots/within
    // radius - 반경(KM 단위) 기본 0.3
    static public func within(lat:String, lon:String, radius:String, start:String, end:String, productType:ProductType, monthlyFrom:String, monthlyCount:Int, filter:FilterType) -> Observable<(Within?, ResponseCodeType)>  {
        let data = ParkinglotAPI.within(lat: lat, lon: lon, radius: radius, start: start, end: end, productType:productType, monthlyFrom: monthlyFrom, monthlyCount: monthlyCount, filter: filter)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Within(JSON: result.data), result.codeType)
            })
    }
    
    static public func available_times(id:Int, from:String, to:String, type:ProductType, monthlyFrom:String, monthlyCount:Int) -> Observable<ResponseCodeType>  {
        let data = ParkinglotAPI.available_times(id: id, from: from, to: to, type: type, monthlyFrom: monthlyFrom, monthlyCount: monthlyCount)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return result.codeType
            })
    }
}
