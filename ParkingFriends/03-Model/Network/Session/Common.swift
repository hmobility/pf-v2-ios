//
//  ParkingLot.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class Common : HttpSession {
    
    // 차량 브랜드 조회 /v1/cars/brands
    static public func cars_brands() -> Observable<(Parkinglots?, ResponseCodeType)>  {
        let data = CommonAPI.cars_brands()
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (Parkinglots(JSON: result.data!), result.codeType)
            })
    }
    
    // 차량 모델 조회 /v1/cars/brands/{brandId}/models
    static public func cars_brands_models(brandId:String) -> Observable<(CarBrands?, ResponseCodeType)>  {
        let data = CommonAPI.cars_brands_models(brandId: brandId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (CarBrands(JSON: result.data!), result.codeType)
            })
       }
    
    // 차량 상세 모델 조회 /v1/cars/brands/{brandId}/models/{modelId}/trims
    static public func cars_brands_models_trim(brandId:String, modelId:String) -> Observable<(CarModels?, ResponseCodeType)>  {
        let data = CommonAPI.cars_brands_models_trims(brandId: brandId, modelId: modelId)
        
        return self.shared.dataTask(httpMethod: data.method, auth:data.auth, path: data.url, parameters: data.params!)
            .map ({  result in
                return (CarModels(JSON: result.data!), result.codeType)
            })
    }
}
